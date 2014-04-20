#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define dm_list_struct_base(v, t, head) \
    ((t *)((const char *)(v) - (const char *)&((t *) 0)->head))
#define dm_list_iterate_items_gen(v, head, field) \
	for (v = dm_list_struct_base((head)->n, __typeof__(*v), field); \
	     &v->field != (head); \
	     v = dm_list_struct_base(v->field.n, __typeof__(*v), field))
#define dm_list_iterate_items(v, head) dm_list_iterate_items_gen(v, (head), list)

struct dm_list{
	struct dm_list *n, *p;
};

struct lv_segment{
	struct dm_list list;
	int flag;
};
struct logical_volume{
	struct lv_segment *snapshot;
	struct dm_list segments;
};

void dm_list_insert(struct dm_list *head, struct dm_list *node)
{
	node->p = head->p;
	node->n = head;
	head->p->n = node;
	head->p = node;
}
void main()
{
	struct lv_segment *seg;
	struct logical_volume *lv, *lv_head;
	lv_head = calloc(1, sizeof(struct logical_volume));
	lv_head->snapshot = calloc(1, sizeof(struct lv_segment));
	lv_head->snapshot->flag = 0;
	printf("head flag: %d\n", lv_head->snapshot->flag);
	int i;
	struct dm_list *head, *node;
	head = &lv_head->snapshot->list;
	head->n = head->p = head;
	for(i = 0; i < 2; i++) {
		lv = calloc(1, sizeof(struct logical_volume));
		lv->snapshot = calloc(1, sizeof(struct lv_segment));
		lv->snapshot->flag = i + 1;
		printf("flag: %d\n", lv->snapshot->flag);
		node = &lv->snapshot->list;
		dm_list_insert(head, node);
	}
	dm_list_iterate_items(seg, &lv_head->segments)
		printf("%x\n", seg->flag);
	exit(0);
}
