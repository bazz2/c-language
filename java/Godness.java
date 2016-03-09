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

private class HumanFactory {
    public static Human createHuman(String gender) {
        Human human = null;
        if (gender.equals("man")) {
            human = new Man();
        } else if (gender.equals("woman")) {
            human = new Woman();
        }
        return human;
    }
}

public class Godness {
    public static void main(String[] args) {
        Human h = HumanFactory.createHuman("man");
        h.Eat();
        h.Sleep();
        h.Beat();
    }
}
