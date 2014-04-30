#include <stdio.h>
#include <stdlib.h>
#include <osn/list.h>

struct en {
	int i;
	struct list_head list;
};
void main()
{
	struct list_head ens1, ens2;
	struct en *en;
	int i;

	INIT_LIST_HEAD(&ens1);
	INIT_LIST_HEAD(&ens2);

	for (i = 0; i < 3; i++) {
		en = calloc(1, sizeof (*en));
		en->i = i+4;
printf("add %d to list\n", en->i);
		list_add_tail(&en->list, &ens1);
		//osn_list_add(&en->list, &ens1);
	}
	for (i = 0; i < 3; i++) {
		en = calloc(1, sizeof (*en));
		en->i = i+1;
printf("add %d to list\n", en->i);
		list_add_tail(&en->list, &ens2);
		//osn_list_add(&en->list, &ens2);
	}

printf("\n ens1======\n");
	list_for_each_entry(en, &ens1, list)
		printf("%d\n", en->i);
printf("\n ens2======\n");
	list_for_each_entry(en, &ens2, list)
		printf("%d\n", en->i);

	list_splice(&ens2, &ens1);
printf("\n ens1(include ens2)======\n");
	list_for_each_entry(en, &ens1, list)
		printf("%d\n", en->i);
}
