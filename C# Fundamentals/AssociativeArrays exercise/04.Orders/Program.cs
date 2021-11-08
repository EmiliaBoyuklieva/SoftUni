using System;
using System.Collections.Generic;

namespace _04.Orders
{
    class Program
    {
        static void Main(string[] args)
        {
            string[] product = Console.ReadLine().Split();

            Dictionary<string, double> products = new Dictionary<string, double>();
            Dictionary<string, double> productsPrice = new Dictionary<string, double>();

            while (product[0] != "buy")
            {
                string name = product[0];
                double price = double.Parse(product[1]);
                double quantity = double.Parse(product[2]);

                if (products.ContainsKey(name))
                {
                    products[name] += quantity;
                    productsPrice[name] = price;
                }
                else
                {
                    products.Add(name, quantity);
                    productsPrice.Add(name, price);
                }

                product = Console.ReadLine().Split();
            }

            foreach (var item in products)
            {
                string name = item.Key;
                double quantity = item.Value;
                double price = productsPrice[name];

                double total = quantity * price;

                Console.WriteLine($"{name} -> {total:f2}");
            }
        }
    }
}
