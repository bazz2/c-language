#include <iostream>
using namespace std;

template <typename objectType>
const objectType& GetMax(const objectType& value1, const objectType& value2)
{
	if (value1 > value2)
		return value1;
	else
		return value2;
}

int main()
{
	int Integer1 = 25;
	int Integer2 = 10;
	// 将模板参数 objectType 指定为 int
	int MaxValue = GetMax <int> (Integer1, Integer2);
	cout << MaxValue << endl;

	// 编译器很聪明，知道这是针对整型调用模板函数,
	// （对于模板类，就必须显性地指定类型，这点和模板函数不一样）
	MaxValue = GetMax(Integer1, Integer2);
	cout << MaxValue << endl;

	double Double1 = 1.1;
	double Double2 = 1.001;
	// 将模板参数 objectType 指定为 double
	double MaxValue2 = GetMax <double> (Double1, Double2);
	cout << MaxValue2 << endl;


	return 0;
}

/**
 * 上述代码将但只编译器生成模板函数 GetMax 的两个版本：
 * const int& GetMax(const int& value1, const int& value2)
 * 和
 * const double& GetMax(const double& value1, const double value2)
 */
