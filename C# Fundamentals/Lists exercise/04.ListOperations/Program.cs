using System;
using System.Collections.Generic;
using System.Linq;

namespace _04.ListOperations
{
    class Program
    {
        static void Main(string[] args)
        {
            List<int> numbers = Console.ReadLine()
                .Split()
                .Select(int.Parse)
                .ToList();

            string command = Console.ReadLine();

            while (command != "End")
            {
                string[] parts = command.Split();
                string currCommand = parts[0];

                if (currCommand == "Add")
                {
                    int element = int.Parse(parts[1]);
                    numbers.Add(element);
                }
                else if (currCommand == "Insert")
                {
                    int element = int.Parse(parts[1]);
                    int index = int.Parse(parts[2]);

                    if (!IsValid(index, numbers))
                    {
                        Console.WriteLine("Invalid index");
                    }
                    else
                    {
                        numbers.Insert(index, element);
                    }
                }
                else if (currCommand == "Remove")
                {
                    int index = int.Parse(parts[1]);

                    if (!IsValid(index, numbers))
                    {
                        Console.WriteLine("Invalid index");
                    }
                    else
                    {
                        numbers.RemoveAt(index);
                    }
                }
                else
                {
                    string possition = parts[1];
                    int count = int.Parse(parts[2]);

                    if (possition == "left")
                    {
                        for (int i = 0; i < count; i++)
                        {
                            int firstElement = numbers[0];
                            numbers.RemoveAt(0);
                            numbers.Add(firstElement);
                        }
                    }
                    else
                    {
                        for (int i = count; i > 0; i--)
                        {
                            int lastElement = numbers[numbers.Count - 1];
                            numbers.RemoveAt(numbers.Count - 1);
                            numbers.Insert(0, lastElement);
                        }
                    }
                }

                command = Console.ReadLine();
            }

            Console.WriteLine(string.Join(" ", numbers));
        }
        static bool IsValid(int index, List<int> numbers)
        {
            return index >= 0 && index < numbers.Count;
        }
    }
    
}
