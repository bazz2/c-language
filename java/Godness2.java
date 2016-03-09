abstract class Human {
    public abstract void Eat();
    public abstract void Sleep();
    public abstract void Beat();
}

class Man extends Human {
    public void Eat() {
        System.out.println("Man can eat.");
    }
    public void Sleep() {
        System.out.println("Man can sleep.");
    }
    public void Beat() {
        System.out.println("Man can beat.");
    }
}
class Woman extends Human {
    public void Eat() {
        System.out.println("Woman can eat.");
    }
    public void Sleep() {
        System.out.println("Woman can sleep.");
    }
    public void Beat() {
        System.out.println("Woman can beat.");
    }
}

abstract class HumanFactory {
    public abstract Human createHuman() throws IOException;
}

class ManFactory extends HumanFactory {
    public Human createHuman() throws IOException {
        return new Man();
    }
}
class WomanFactory extends HumanFactory {
    public Human createHuman() throws IOException {
        return new Woman();
    }
}

public class Goddess2 {
    public static void main(String[] args) throws IOException {
        HumanFactory hf = new ManFactory();
        Human h = hf.createHuman();
        h.Eat();
        h.Sleep();
        h.Beat();
    }
}
