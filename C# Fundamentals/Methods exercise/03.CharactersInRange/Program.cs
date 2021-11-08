using System;

namespace _03.CharactersInRange
{
    class Program
    {
        static void Main(string[] args)
        {
            char start = char.Parse(Console.ReadLine());
            char end = char.Parse(Console.ReadLine());

            char start1 = ' ';
            char end1 = ' ';

            if (start > end)
            {
                start1 = end;
                end1 = start;
            }
            else
            {
                start1 = start;
                end1 = end;
            }

            GetRange(start1, end1);
        }
        static void GetRange(char start, char end)
        {
            for (int i = start + 1; i < end; i++)
            {
                Console.Write((char)i + " ");
            }

            Console.WriteLine();
        }
    }
    
}
