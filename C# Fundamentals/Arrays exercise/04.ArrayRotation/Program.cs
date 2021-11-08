using System;

namespace _04.ArrayRotation
{
    class Program
    {
        static void Main(string[] args)
        {
            string[] array = Console.ReadLine()
             .Split();

            int rotation = int.Parse(Console.ReadLine());

            rotation = rotation % array.Length;

            for (int i = 0; i < rotation; i++)
            {
                string firstElement = array[0];

                for (int j = 1; j < array.Length; j++)
                {
                    int index = j - 1;
                    array[index] = array[j];
                }

                array[array.Length - 1] = firstElement;
            }

            Console.WriteLine(string.Join(" ", array));
        }
    }
}
