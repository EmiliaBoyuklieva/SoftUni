using System;

namespace _03.Vacation
{
    class Program
    {
        static void Main(string[] args)
        {
            int group = int.Parse(Console.ReadLine());
            string typeOfGroup = Console.ReadLine();
            string day = Console.ReadLine();

            double price = 0;
            double discount = 0;

            switch (day)
            {
                case "Friday":
                    switch (typeOfGroup)
                    {
                        case "Students":
                            price = 8.45;
                            break;
                        case "Business":
                            price = 10.90;
                            break;
                        case "Regular":
                            price = 15;
                            break;
                    }
                    break;
                case "Saturday":
                    switch (typeOfGroup)
                    {
                        case "Students":
                            price = 9.80;
                            break;
                        case "Business":
                            price = 15.60;
                            break;
                        case "Regular":
                            price = 20;
                            break;
                    }
                    break;
                case "Sunday":
                    switch (typeOfGroup)
                    {
                        case "Students":
                            price = 10.46;
                            break;
                        case "Business":
                            price = 16;
                            break;
                        case "Regular":
                            price = 22.50;
                            break;
                    }
                    break;

            }

            double totalPrice = price * group;

            if (group >= 30 && typeOfGroup == "Students")
            {
                discount = 0.15;
                totalPrice -= totalPrice * discount;
            }
            if (group >= 100 && typeOfGroup == "Business")
            {
                int newGroup = group - 10;
                totalPrice = price * newGroup;
            }
            if (group >= 10 && group <= 20 && typeOfGroup == "Regular")
            {
                discount = 0.05;
                totalPrice -= totalPrice * discount;
            }

            Console.WriteLine($"Total price: {totalPrice:f2}");
        }
    }
}
