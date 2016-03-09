import java.util.LinkedList;

class GenericStack<T> {
    // ������һ����������Ϊ T �ķ���

    private LinkedList<T> stackContainer = new LinkedList<T>();
    // ʹ�� T ���͵� LinkedList������ ��Ϊջ������

    public void push(T t) {
        stackContainer.addFirst(t);
        // �Զ���һ����ջ�ķ��������� addFirst() ����
        // addFirst() ����������ջ�Ķ��˼���Ԫ��
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
