using System;
using System.Collections.Generic;

namespace _05.MultiplyBigNumber
{
    class Program
    {
        static void Main(string[] args)
        {
            List<string> rezult = new List<string>();

            string number = Console.ReadLine();
            int multiplier = int.Parse(Console.ReadLine());

            int remainder = 0;

            for (int i = number.Length - 1; i >= 0; i--)
            {
                int digit = number[i] - '0';

                if (multiplier == 0)
                {
                    rezult.Add(0.ToString());
                    break;
                }

                remainder += digit * multiplier;

                if (remainder > 9)
                {
                    int remainderLast = remainder % 10;
                    remainder /= 10;
                    rezult.Add(remainderLast.ToString());
                }
                else
                {
                    rezult.Add(remainder.ToString());
                    remainder = 0;
                }
            }

            if (remainder > 0)
            {
                rezult.Add(remainder.ToString());
            }

            rezult.Reverse();

            Console.WriteLine(string.Concat(rezult));
        }
    }
}
