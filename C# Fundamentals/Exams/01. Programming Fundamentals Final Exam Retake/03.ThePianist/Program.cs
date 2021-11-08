using System;
using System.Linq;
using System.Collections.Generic;

namespace _03.ThePianist
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = int.Parse(Console.ReadLine());
            Dictionary<string, string> pieceCompose = new Dictionary<string, string>();
            Dictionary<string, string> pieceKey = new Dictionary<string, string>();

            for (int i = 0; i < n; i++)
            {
                string[] piece = Console.ReadLine().Split("|");

                string pieceName = piece[0];
                string compose = piece[1];
                string key = piece[2];

                pieceCompose.Add(pieceName, compose);
                pieceKey.Add(pieceName, key);

            }
            string command = Console.ReadLine();

            while (command != "Stop")
            {

                string[] parts = command.Split("|");
                string operation = parts[0];
                string pieceName = parts[1];

                if (operation == "Add")
                {
                    string compose = parts[2];
                    string key = parts[3];

                    if (pieceCompose.ContainsKey(pieceName))
                    {
                        Console.WriteLine($"{pieceName} is already in the collection!");
                    }
                    else
                    {
                        pieceCompose.Add(pieceName, compose);
                        pieceKey.Add(pieceName, key);
                        Console.WriteLine($"{ pieceName } by { compose} in { key} added to the collection!");
                    }
                   

                }
                else if (operation == "Remove")
                {

                    if (pieceCompose.ContainsKey(pieceName))
                    {
                        pieceCompose.Remove(pieceName);
                        pieceKey.Remove(pieceName);
                        Console.WriteLine($"Successfully removed {pieceName}!");
                    }
                    else
                    {
                        Console.WriteLine($"Invalid operation! {pieceName} does not exist in the collection.");
                    }


                }
                else if (operation == "ChangeKey")
                {
                    string key = parts[2];

                    if (pieceKey.ContainsKey(pieceName))
                    {
                        pieceKey[pieceName] = key;
                        Console.WriteLine($"Changed the key of { pieceName} to {key}!");
                    }
                    else
                    {
                        Console.WriteLine($"Invalid operation! {pieceName} does not exist in the collection.");
                    }
                }
                command = Console.ReadLine();
               
            }
            Dictionary<string, string> sorted = pieceCompose.OrderBy(x => x.Key).ThenBy(x => x.Value).ToDictionary(x => x.Key, x => x.Value);
            foreach (var item in sorted)
            {
                string name = item.Key;
                string composer = item.Value;
                string key = pieceKey[name];
                Console.WriteLine($"{name} -> Composer: { composer}, Key: { key}");
            }
        }
    }
}
