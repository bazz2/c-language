enum Week {
    MONDAY("MON", 1),TUESDAY("TUES",2),WEDNESDAY("WED",3),THURSDAY("THUR",4),
    FRIDAY("FRI",5),SATURDAY("SAT",6),SUNDAY("SUN",7);

    private String abbr;
    private int num;
    private Week(String abbr, int num) {
        this.abbr = abbr;
        this.num = num;
    }

    public String getAbbr() {
        return abbr;
    }
    public String toString() {
        return super.toString() + "(" + abbr + "," + num + ")";
    }
}

public class EnumPractice {
    public static void main(String[] args) {

        for (Week week : Week.values()) {
            System.out.println("The order of " + week + " is " + week.ordinal());
            System.out.println("Compare to MONDAY: " + week.compareTo(Week.MONDAY));
            System.out.println("Equal to MONDAY ?" + week.equals(Week.MONDAY));
            System.out.println("== MONDAY ?" + (week == Week.MONDAY));
            System.out.println("Name: " + week.name());
            System.out.println("Abbr: " + week.getAbbr());
            System.out.println("------------------");
        }
    }
}
