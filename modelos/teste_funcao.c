#include <assert.h>

static int exemplo(int valor) {
    return valor * 2;
}

int main(void) {
    assert(exemplo(0) == 0);
    assert(exemplo(3) == 6);
    assert(exemplo(-2) == -4);
    return 0;
}
