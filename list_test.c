#include <stdio.h>
#include "list.h"

struct ne {
    int id;
    struct list_head list;
};
int main()
{
    struct list_head nes, *nesp;
    struct ne *nep;
    int i;

    INIT_LIST_HEAD(&nes);
    for (i = 0; i < 5; i++) {
        nep = (struct ne*)calloc(1, sizeof (struct ne));
        if (nep == NULL)
            break;
        nep->id = i;
        list_add_tail(&nep->list, &nes);
    }

    list_for_each_entry(nep, &nes, list) {
        printf("%d\n", nep->id);
    }

    nesp = &nes;
    list_for_each_entry(nep, nesp, list) {
        printf("%d\n", nep->id);
    }
    return 0;
}
