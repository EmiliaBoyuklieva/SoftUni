using System;

namespace _02.MuOnline
{
    class Program
    {
        static void Main(string[] args)
        {
            int health = 100;
            int bitcoins = 0;
            int current = 0;
            bool isAlive = true;

            string[] rooms = Console.ReadLine().Split('|');

            for (int i = 0; i < rooms.Length; i++)
            {
                string[] splittedRoom = rooms[i].Split();

                string command = (splittedRoom[0]);
                int number = int.Parse(splittedRoom[1]);

                if (command == "potion")
                {
                    health += number;

                    if (health > 100)
                    {
                        health = 100;
                        current = 100 - current;
                    }
                    else
                    {
                        current = number;
                    }

                    Console.WriteLine($"You healed for {current} hp.");
                    Console.WriteLine($"Current health: {health} hp.");
                }
                else if (command == "chest")
                {
                    bitcoins += number;
                    Console.WriteLine($"You found {number} bitcoins.");
                }
                else
                {
                    health -= number;
                    current = health;

                    if (health > 0)
                    {
                        Console.WriteLine($"You slayed {command}.");

                    }
                    else
                    {
                        Console.WriteLine($"You died! Killed by {command}.");
                        Console.WriteLine($"Best room: {i + 1}");
                        isAlive = false;
                        break;

                    }
                }

            }
            if (isAlive)
            {
                Console.WriteLine($"You've made it!");
                Console.WriteLine($"Bitcoins: { bitcoins}");
                Console.WriteLine($"Health: {health}");
            }
        }
    }
}
