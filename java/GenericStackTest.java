import java.util.LinkedList;

class GenericStack<T> {
    // 定义了一个参数类型为 T 的泛型

    private LinkedList<T> stackContainer = new LinkedList<T>();
    // 使用 T 类型的 LinkedList（链表） 作为栈的容器

    public void push(T t) {
        stackContainer.addFirst(t);
        // 自定义一个入栈的方法，调用 addFirst() 方法
        // addFirst() 方法可以在栈的顶端加入元素
        stackContainer.addFirst(t);
    }

    public T pop() {
        return stackContainer.removeFirst();
    }

    public boolean isEmpty() {
        return stackContainer.isEmpty();
    }
}

public class GenericStackTest {
    public static void main(String[] args) {
        GenericStack<String> stack = new GenericStack<String>();

        System.out.println("Now add some words into stack.");
        stack.push("hello");
        stack.push("world");
        System.out.println("Stack: " + stack);
        String s = (String)stack.pop();
        System.out.println("Stack pop " + s);
    }
}
