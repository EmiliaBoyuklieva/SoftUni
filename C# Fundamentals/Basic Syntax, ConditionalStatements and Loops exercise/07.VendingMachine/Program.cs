using System;

namespace _07.VendingMachine
{
    class Program
    {
        static void Main(string[] args)
        {
            string command = Console.ReadLine();

            double currentBalance = 0;

            while (command != "Start")
            {
                double coin = double.Parse(command);
                if (coin == 0.1 || coin == 0.2 || coin == 0.5 || coin == 1 || coin == 2)
                {
                    currentBalance += coin;
                }
                else
                {
                    Console.WriteLine($"Cannot accept {coin}");
                }

                command = Console.ReadLine();
            }

            string productType = Console.ReadLine();

            double price = 0;

            while (productType != "End")
            {
                if (productType == "Nuts")
                {
                    price = 2.0;
                }
                else if (productType == "Water")
                {
                    price = 0.7; ;
                }
                else if (productType == "Crisps")
                {
                    price = 1.5;
                }
                else if (productType == "Soda")
                {
                    price = 0.8;
                }
                else if (productType == "Coke")
                {
                    price = 1.0;
                }

                if (price != 0)
                {
                    if (currentBalance >= price)
                    {
                        Console.WriteLine($"Purchased {productType.ToLower()}");
                        currentBalance -= price;
                    }
                    else
                    {

                        Console.WriteLine("Sorry, not enough money");
                    }

                }
                else
                {
                    Console.WriteLine("Invalid product");
                }

                productType = Console.ReadLine();
            }

            Console.WriteLine($"Change: {currentBalance:F2}");
        }
    }
}
