#include <iostream>
#include <string>
using namespace std;

class CDisplay
{
public:
	void operator() (string Input) const
	{
		cout << Input << endl;
	}
};

int main()
{
	CDisplay mDisplayFuncObject;

	/* 将对象当作函数处理，是因为编译器隐式地将它转换为对函数operator()的调用 */
	mDisplayFuncObject ("Display this sentance");

	return 0;
}
