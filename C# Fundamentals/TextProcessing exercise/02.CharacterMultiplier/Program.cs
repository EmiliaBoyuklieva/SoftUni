using System;

namespace _02.CharacterMultiplier
{
    class Program
    {
        static void Main(string[] args)
        {
            string[] input = Console.ReadLine().Split();

            string first = input[0];
            string second = input[1];

            int minLenght = Math.Min(first.Length, second.Length);
            int sum = 0;

            for (int i = 0; i < minLenght; i++)
            {
                sum += first[i] * second[i];
            }
            if (first.Length > second.Length)
            {
                sum += Sum(first, minLenght);
            }
            if (second.Length > first.Length)
            {
                sum += Sum(second, minLenght);
            }
            Console.WriteLine(sum);
        }
        static int Sum(string word, int index)
        {
            int sum = 0;

            for (int i = index; i < word.Length; i++)
            {
                sum += word[i];
            }
            return sum;
        }
    }
}
