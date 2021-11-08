using System;
using System.Linq;

namespace _11.ArrayManipulator
{
    class Program
    {
        static void Main(string[] args)
        {
            int[] arr = Console.ReadLine()
                .Split(' ', StringSplitOptions.RemoveEmptyEntries)
                .Select(int.Parse)
                .ToArray();

            string input = Console.ReadLine();

            while (input != "end")
            {
                string[] command = input.Split();

                if (command[0] == "exchange")
                {
                    if (int.Parse(command[1]) < 0 || int.Parse(command[1]) >= arr.Length)
                    {
                        Console.WriteLine("Invalid index");
                        continue;
                    }

                    Exchange(arr, int.Parse(command[1]));
                }
                else if (command[0] == "max")
                {
                    if (command[1] == "even")
                    {
                        if (EvenMax(arr) == -1)
                        {
                            Console.WriteLine("No matches");
                            continue;
                        }

                        Console.WriteLine(EvenMax(arr));
                    }
                    else
                    {
                        if (OddMax(arr) == -1)
                        {
                            Console.WriteLine("No matches");
                            continue;
                        }

                        Console.WriteLine(OddMax(arr));
                    }
                }
                else if (command[0] == "min")
                {
                    if (command[1] == "even")
                    {
                        if (EvenMin(arr) == -1)
                        {
                            Console.WriteLine("No matches");
                            continue;
                        }

                        Console.WriteLine(EvenMin(arr));
                    }
                    else
                    {
                        if (OddMin(arr) == -1)
                        {
                            Console.WriteLine("No matches");
                            continue;
                        }

                        Console.WriteLine(OddMin(arr));
                    }
                }
                else if (command[0] == "first")
                {
                    if (int.Parse(command[1]) > arr.Length)
                    {
                        Console.WriteLine("Invalid count");
                        continue;
                    }

                    if (command[2] == "even")
                    {
                        EvenFirst(arr, int.Parse(command[1]));
                    }
                    else
                    {
                        OddFirst(arr, int.Parse(command[1]));
                    }
                }
                else if (command[0] == "last")
                {
                    if (int.Parse(command[1]) > arr.Length)
                    {
                        Console.WriteLine("Invalid count");
                        continue;
                    }

                    if (command[2] == "even")
                    {
                        EvenLast(arr, int.Parse(command[1]));
                    }
                    else
                    {
                        OddLast(arr, int.Parse(command[1]));
                    }
                }

                input = Console.ReadLine();
            }

            Console.WriteLine("[" + string.Join(", ", arr) + "]");
        }
        static void Exchange(int[] array, int index)
        {
            int[] firstArray = new int[array.Length - index - 1];
            int[] secondAray = new int[index + 1];

            int firstArrCounter = 0;

            for (int i = index + 1; i < array.Length; i++)
            {
                firstArray[firstArrCounter] = array[i];
                firstArrCounter++;

            }

            for (int i = 0; i < index + 1; i++)
            {
                secondAray[i] = array[i];
            }

            for (int i = 0; i < firstArray.Length; i++)
            {
                array[i] = firstArray[i];
            }

            for (int i = 0; i < secondAray.Length; i++)
            {
                array[firstArray.Length + i] = secondAray[i];

            }
        }

        static int EvenMax(int[] array)
        {
            int evenMax = int.MinValue;
            int currentIndex = -1;

            for (int i = 0; i < array.Length; i++)
            {
                if (array[i] % 2 == 0)
                {
                    if (array[i] >= evenMax)
                    {
                        evenMax = array[i];
                        currentIndex = i;
                    }
                }
            }

            return currentIndex;
        }

        static int OddMax(int[] array)
        {
            int oddMax = int.MinValue;
            int currentIndex = -1;

            for (int i = 0; i < array.Length; i++)
            {
                if (array[i] % 2 != 0)
                {
                    if (array[i] >= oddMax)
                    {
                        oddMax = array[i];
                        currentIndex = i;
                    }
                }
            }

            return currentIndex;
        }
        static int EvenMin(int[] array)
        {
            int evenMin = int.MaxValue;
            int currentIndex = -1;

            for (int i = 0; i < array.Length; i++)
            {
                if (array[i] % 2 == 0)
                {
                    if (array[i] <= evenMin)
                    {
                        evenMin = array[i];
                        currentIndex = i;
                    }
                }
            }

            return currentIndex;
        }

        static int OddMin(int[] array)
        {
            int oddMin = int.MaxValue;
            int current = -1;

            for (int i = 0; i < array.Length; i++)
            {
                if (array[i] % 2 != 0)
                {
                    if (array[i] <= oddMin)
                    {
                        oddMin = array[i];
                        current = i;
                    }
                }
            }

            return current;
        }

        static void EvenFirst(int[] array, int count)
        {
            int counter = 0;
            string numbers = string.Empty;

            for (int i = 0; i < array.Length; i++)
            {
                if (array[i] % 2 == 0)
                {
                    numbers += array[i] + " ";
                    counter++;
                }
                if (counter == count)
                {
                    break;
                }
            }

            string[] result = numbers.Split(' ', StringSplitOptions.RemoveEmptyEntries);

            if (counter == 0)
            {
                Console.WriteLine("[]");
            }
            else
            {
                Console.WriteLine("[" + string.Join(", ", result) + "]");

            }
        }

        static void OddFirst(int[] array, int count)
        {
            int counter = 0;
            string numbers = string.Empty;

            for (int i = 0; i < array.Length; i++)
            {
                if (array[i] % 2 != 0)
                {
                    numbers += array[i] + " ";
                    counter++;
                }

                if (counter == count)
                {
                    break;
                }
            }

            string[] result = numbers.Split(' ', StringSplitOptions.RemoveEmptyEntries);

            if (counter == 0)
            {
                Console.WriteLine("[]");
            }
            else
            {
                Console.WriteLine("[" + string.Join(", ", result) + "]");
            }
        }

        static void EvenLast(int[] array, int count)
        {
            int counter = 0;
            string numbers = string.Empty;

            for (int i = array.Length - 1; i >= 0; i--)
            {
                if (array[i] % 2 == 0)
                {
                    numbers += array[i] + " ";
                    counter++;
                }
                if (counter == count)
                {
                    break;
                }
            }
            string[] result = numbers.Split(' ', StringSplitOptions.RemoveEmptyEntries);

            if (counter == 0)
            {
                Console.WriteLine("[]");
            }
            else
            {
                Console.WriteLine("[" + string.Join(", ", result.Reverse()) + "]");
            }
        }

        static void OddLast(int[] array, int count)
        {
            int counter = 0;
            string numbers = string.Empty;

            for (int i = array.Length - 1; i >= 0; i--)
            {
                if (array[i] % 2 != 0)
                {
                    numbers += array[i] + " ";
                    counter++;
                }
                if (counter == count)
                {
                    break;
                }
            }

            string[] result = numbers.Split(' ', StringSplitOptions.RemoveEmptyEntries);

            if (counter == 0)
            {
                Console.WriteLine("[]");
            }
            else
            {
                Console.WriteLine("[" + string.Join(", ", result.Reverse()) + "]");

            }
        }
    }
}
