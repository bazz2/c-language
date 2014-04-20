/*gcc -o dm-pool dm-pool.c -ldevmapper*/
#include <stdio.h>
#include <libdevmapper.h>
int main()
{
        struct dm_pool *p;
        int i;
        char buffer[1024];

        if (NULL == (p = dm_pool_create("test", 0))) {
                printf("failed to create dm_pool\n");
                return 1;
        }

        if (!dm_pool_begin_object(p, 128)) {
                return 1;
        }

        for (i = 0; i < 10; i++) {
                dm_snprintf(buffer, sizeof(buffer), "this is string %d\n", i);
                if (!dm_pool_grow_object(p, buffer, strlen(buffer))) {
                        printf("failed to grow object\n");
                        goto bad;
                }
        }
        printf("%s\n", (char *) dm_pool_end_object(p));
bad:
        dm_pool_abandon_object(p);
        dm_free(p);
        return 0;
}
