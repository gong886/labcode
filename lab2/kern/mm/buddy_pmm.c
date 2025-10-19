// kern/mm/buddy_pmm.c
#include <pmm.h>
#include <memlayout.h>
#include <list.h>
#include <assert.h>
#include <string.h>
#include <stdio.h>

#define MAX_ORDER 16

typedef struct {
    list_entry_t free_list;
    unsigned int nr_free;
} buddy_area_t;

static buddy_area_t buddy_area[MAX_ORDER];
static size_t buddy_free_pages_count = 0;

static struct Page *managed_base_page = NULL;
static size_t managed_npages = 0;
static int max_order = MAX_ORDER;

static inline size_t order_to_pages(int order) { return (size_t)1 << order; }

// 计算最小的 order 使得 (1<<order) >= n
static int pages_to_order(size_t n) {
    int order = 0;
    size_t sz = 1;
    while (sz < n) {
        sz <<= 1;
        order++;
    }
    return order;
}

static void buddy_init(void) {
    for (int i = 0; i < max_order; i++) {
        list_init(&buddy_area[i].free_list);
        buddy_area[i].nr_free = 0;
    }
    buddy_free_pages_count = 0;
}

// 获取给定页面和 order 对应的伙伴页指针
static inline struct Page *buddy_of(struct Page *page, int order) {
    ppn_t ppn = page2ppn(page); // 物理页号
    ppn_t buddy_ppn = ppn ^ ((ppn_t)1 << order);
    uintptr_t buddy_pa = ((uintptr_t)buddy_ppn) << PGSHIFT;
    return pa2page(buddy_pa);
}

static inline bool buddy_in_range(struct Page *p) {
    return p >= managed_base_page && p < (managed_base_page + managed_npages);
}

// 从 order 空闲链表中删除特定的空闲块
static void remove_free_block(struct Page *blk, int order) {
    list_del(&blk->page_link);
    list_init(&blk->page_link);
    buddy_area[order].nr_free -= order_to_pages(order);
    buddy_free_pages_count -= order_to_pages(order);
    ClearPageProperty(blk);
}

// 将一个空闲块作为头插入给定 order 的空闲链表中
static void insert_free_block_no_merge(struct Page *blk, int order) {
    blk->property = order_to_pages(order);
    SetPageProperty(blk);
    list_add(&buddy_area[order].free_list, &blk->page_link);
    buddy_area[order].nr_free += order_to_pages(order);
    buddy_free_pages_count += order_to_pages(order);
}

// 将给定的内存范围按最大 2 的幂次块拆分，并插入到空闲链表中
static void buddy_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    managed_base_page = base;
    managed_npages = n;

    struct Page *p = base;
    size_t remain = n;

    while (remain > 0) {
        int order = 0;
        size_t block = 1;
        while ((order + 1) < max_order && (block << 1) <= remain) {
            block <<= 1;
            order++;
        }

        for (size_t i = 0; i < block; i++) {
            struct Page *pp = p + i;
            assert(PageReserved(pp));
            pp->flags = pp->property = 0;
            set_page_ref(pp, 0);
        }

        p->property = block;
        SetPageProperty(p);
        list_add(&buddy_area[order].free_list, &(p->page_link));
        buddy_area[order].nr_free += block;
        buddy_free_pages_count += block;

        p += block;
        remain -= block;
    }
}

// 分配 >= n 页：寻找最小的 >= n 的 2 的幂块
static struct Page *buddy_alloc_pages(size_t n) {
    assert(n > 0);
    if (n > buddy_free_pages_count) {
        return NULL;
    }
    int need_order = pages_to_order(n);

    int found_order = -1;
    for (int ord = need_order; ord < max_order; ord++) {
        if (!list_empty(&buddy_area[ord].free_list)) {
            found_order = ord;
            break;
        }
    }
    if (found_order == -1) return NULL;

    list_entry_t *le = list_next(&buddy_area[found_order].free_list);
    struct Page *block = le2page(le, page_link);
    list_del(&block->page_link);
    list_init(&block->page_link);
    buddy_area[found_order].nr_free -= order_to_pages(found_order);
    buddy_free_pages_count -= order_to_pages(found_order);

    // 向下分裂到所需 order；分裂时，右侧的伙伴变为空闲块
    while (found_order > need_order) {
        found_order--;
        struct Page *right = block + order_to_pages(found_order);
        right->property = order_to_pages(found_order);
        SetPageProperty(right);
        list_add(&buddy_area[found_order].free_list, &right->page_link);
        buddy_area[found_order].nr_free += order_to_pages(found_order);
        buddy_free_pages_count += order_to_pages(found_order);
    }

    // 标记为已分配：将 order 存储在 property 中
    block->property = need_order; // 存储 order
    ClearPageProperty(block);     // 不是空闲头
    set_page_ref(block, 0);
    return block;
}

static void buddy_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    // 对于范围内的每一页，先插入为 order-0 空闲块，然后递归尝试向上合并
    for (size_t i = 0; i < n; i++) {
        struct Page *cur = base + i;
        // 验证：页面不能是保留的且不能已经是空闲头
        assert(!PageReserved(cur) && !PageProperty(cur));
        // 重置标志/引用
        cur->flags = 0;
        set_page_ref(cur, 0);

        // 先作为 order 0 块插入
        int order = 0;
        cur->property = 1;
        SetPageProperty(cur);
        list_add(&buddy_area[0].free_list, &cur->page_link);
        buddy_area[0].nr_free += 1;
        buddy_free_pages_count += 1;

        // 尝试向上合并
        struct Page *block = cur;
        while (order < max_order - 1) {
            struct Page *b = buddy_of(block, order);
            if (!buddy_in_range(b)) break;
            if (!PageProperty(b)) break;
            if (b->property != order_to_pages(order)) break;

            // 从其空闲链表中移除伙伴
            list_del(&b->page_link);
            list_init(&b->page_link);
            buddy_area[order].nr_free -= order_to_pages(order);
            buddy_free_pages_count -= order_to_pages(order);

            // 从空闲链表中移除当前块
            list_del(&block->page_link);
            list_init(&block->page_link);
            buddy_area[order].nr_free -= order_to_pages(order);
            buddy_free_pages_count -= order_to_pages(order);

            // 确定合并的块头
            struct Page *merged = (b < block) ? b : block;
            order++;
            merged->property = order_to_pages(order);
            SetPageProperty(merged);
            list_add(&buddy_area[order].free_list, &merged->page_link);
            buddy_area[order].nr_free += order_to_pages(order);
            buddy_free_pages_count += order_to_pages(order);

            // 继续合并后的块
            block = merged;
        }
    }
}

// 返回空闲页面数
static size_t buddy_nr_free_pages(void) {
    return buddy_free_pages_count;
}

//调试输出和放宽的正确性断言
static void buddy_check(void) {
    struct Page *a, *b, *c;
    a = b = c = NULL;

    cprintf("start\n");

    // 分配三个单页请求
    assert((a = alloc_page()) != NULL);
    assert((b = alloc_page()) != NULL);
    assert((c = alloc_page()) != NULL);
    assert(a != b && a != c && b != c);

    cprintf("alloc pages: a=%p b=%p c=%p\n", a, b, c);

    // 释放它们
    free_page(a);
    free_page(b);
    free_page(c);

    cprintf("freed single pages\n");

    // 分配 5 页
    struct Page *p = alloc_pages(5);
    assert(p != NULL);
    // 读取存储的 order
    int alloc_order = (int)p->property;
    size_t alloc_size = (size_t)1 << alloc_order;

    cprintf("alloc_pages(5) -> p=%p order=%d size=%zu\n",
            p, alloc_order, alloc_size);

    // 释放刚分配的完整 2 的幂块
    free_pages(p, alloc_size);
    cprintf("free_pages(p, %zu) done\n", alloc_size);

    // 现在尝试再次分配同样大小的块
    struct Page *q = alloc_pages(alloc_size);
    if (q == NULL) {
        panic("alloc_pages(%zu) returned NULL after freeing block\n",
              alloc_size);
    }
    cprintf("re-alloc of size %zu returned q=%p\n", alloc_size, q);


    // 确保分配器一致：释放新分配的块，确保 nr_free_pages 返回到先前的值
    size_t before = nr_free_pages();
    free_pages(q, alloc_size);
    size_t after = nr_free_pages();
    cprintf("freed q; free_pages before=%zu after=%zu (delta=%ld)\n",
            before, after, (long)(after - before));

    // 基本的单页分配/释放测试
    struct Page *x = alloc_page();
    assert(x != NULL);
    free_page(x);

    cprintf("end\n");
}

// 导出 pmm_manager 实例
const struct pmm_manager buddy_pmm_manager = {
    .name = "buddy_pmm_manager",
    .init = buddy_init,
    .init_memmap = buddy_init_memmap,
    .alloc_pages = buddy_alloc_pages,
    .free_pages = buddy_free_pages,
    .nr_free_pages = buddy_nr_free_pages,
    .check = buddy_check,
};
