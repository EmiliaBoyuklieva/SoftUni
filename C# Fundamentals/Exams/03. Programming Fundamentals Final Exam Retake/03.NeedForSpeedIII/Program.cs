using System;
using System.Collections.Generic;
using System.Linq;

namespace _03.NeedForSpeedIII
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = int.Parse(Console.ReadLine());
            Dictionary<string, int> carsFuel = new Dictionary<string, int>();
            Dictionary<string, int> carsMileage = new Dictionary<string, int>();
            
            for (int i = 0; i < n; i++)
            {
                string[] cars = Console.ReadLine().Split("|");

                string carName = cars[0];
                int mileage = int.Parse(cars[1]);
                int fuel = int.Parse(cars[2]);

                carsFuel.Add(carName, fuel);
                carsMileage.Add(carName, mileage);

            }
            string command = Console.ReadLine();

            while(command!="Stop")
            {

                string[] parts = command.Split(" : ");
                string operation = parts[0];
                string car = parts[1];

                if (operation == "Drive")
                {
                  
                    int distance = int.Parse(parts[2]);
                    int fuel = int.Parse(parts[3]);
                   
                    if(carsFuel[car] < fuel )
                    {
                        Console.WriteLine("Not enough fuel to make that ride");
                    }
                    
                    else
                    {
                        carsFuel[car] -= fuel;
                        carsMileage[car] += distance;
                        Console.WriteLine($"{ car} driven for { distance} kilometers. { fuel} liters of fuel consumed.");
                    }
                    if (carsMileage[car] >= 100000)
                    {

                        Console.WriteLine($"Time to sell the { car}!");
                        carsFuel.Remove(car);
                        carsMileage.Remove(car);

                    }

                }
                else if (operation == "Refuel")
                {
                    int fuel = int.Parse(parts[2]);
                    int fuelBefore = fuel;

                    carsFuel[car] += fuel;

                    if (carsFuel[car] > 75)
                    {
                        carsFuel[car] = 75;

                        int fuelAfter = carsFuel[car];

                        Console.WriteLine($"{car} refueled with {fuelAfter - fuelBefore} liters");
                        command = Console.ReadLine();
                        continue;
                    }


                    Console.WriteLine($"{car} refueled with {fuel} liters");

                }
                else if (operation== "Revert")
                {
                    int kilometers = int.Parse(parts[2]);

                    carsMileage[car] -= kilometers;
                    

                    if(carsMileage[car] < 10000)
                    {
                        carsMileage[car] = 10000;
                    }
                    else
                    {
                        Console.WriteLine($"{ car} mileage decreased by { kilometers} kilometers");
                    }
                        


                }



                command = Console.ReadLine();
            }

            Dictionary<string, int> sorted = carsMileage.OrderByDescending(m => m.Value).ThenBy(n => n.Key).ToDictionary(x => x.Key, x => x.Value);

            foreach (var item in sorted)
            {
                string carName = item.Key;
                int mileage = item.Value;
                int fuel = carsFuel[carName];

                Console.WriteLine($"{carName} -> Mileage: {mileage} kms, Fuel in the tank: {fuel} lt.");
            }
        }
    }
}
