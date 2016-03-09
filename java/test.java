public class test {
    public static void main(String[] args) {
        String a = "¹þ¹þ";
        try {
            byte[] aa = a.getBytes("GB2312");
            byte[] ab = a.getBytes("UTF-8");
            for (int i = 0; i < aa.length; i++) {
                System.out.print(aa[i]);
            }
            System.out.println();

            for (int i = 0; i < ab.length; i++) {
                System.out.print(ab[i]);
            }
            System.out.println();
        } catch (UnsupportedEncodingException e) {
            e.printStatckTrace();
        }
    }
}
