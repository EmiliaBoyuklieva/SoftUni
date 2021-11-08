using System;

namespace _03.ExtractFile
{
    class Program
    {
        static void Main(string[] args)
        {
            string[] path = Console.ReadLine().Split("\\");

            string lastElement = path[path.Length - 1];

            string[] parts = lastElement.Split(".");

            Console.WriteLine($"File name: {parts[0]}");
            Console.WriteLine($"File extension: {parts[1]}");
        }
    }
}
