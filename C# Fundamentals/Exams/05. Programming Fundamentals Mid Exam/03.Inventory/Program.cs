using System;
using System.Collections.Generic;
using System.Linq;

namespace _03.Inventory
{
    class Program
    {
        static void Main(string[] args)
        {
            List<string> catalogue = Console.ReadLine().Split(", ").ToList();

            string[] command = Console.ReadLine().Split(" - ");


            while (command[0] != "Craft!")
            {
                string operation = command[0];
                string item = command[1];

                if (operation == "Collect")
                {
                    if (!(catalogue.Contains(item)))

                    {
                        catalogue.Add(item);
                    }
                }
                else if (operation == "Drop")
                {
                    if (catalogue.Contains(item))
                    {
                        catalogue.Remove(item);
                    }

                }
                else if (operation == "Combine Items")
                {
                    string[] parts = item.Split(':');
                    string newElement = parts[1];
                    string oldElement = parts[0];

                    if (catalogue.Contains(oldElement))
                    {
                        int index = catalogue.IndexOf(oldElement);
                        catalogue.Insert(index + 1, newElement);
                    }

                }
                else if (operation == "Renew")
                {

                    if (catalogue.Contains(item))
                    {

                        catalogue.Remove(item);
                        catalogue.Add(item);

                    }
                }

                command = Console.ReadLine().Split(" - ");
            }
            Console.WriteLine(string.Join(", ", catalogue));
        }
    }
}
