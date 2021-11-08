using System;

namespace _08.BeerKegs
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = int.Parse(Console.ReadLine());

            double bestVolume = 0;
            string bestModel = string.Empty;

            for (int i = 0; i < n; i++)
            {
                string model = Console.ReadLine();
                double radius = double.Parse(Console.ReadLine());
                int height = int.Parse(Console.ReadLine());

                double volume = Math.PI * Math.Pow(radius, 2) * height;

                if (bestVolume < volume)
                {
                    bestVolume = volume;
                    bestModel = model;
                }
            }

            Console.WriteLine(bestModel);
        }
    }
}
