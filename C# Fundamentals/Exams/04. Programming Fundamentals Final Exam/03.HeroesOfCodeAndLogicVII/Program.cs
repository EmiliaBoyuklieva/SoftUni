using System;
using System.Collections.Generic;
using System.Linq;

namespace _03.HeroesOfCodeAndLogicVII
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = int.Parse(Console.ReadLine());

            Dictionary<string, int> heroHp = new Dictionary<string, int>();
            Dictionary<string, int> heroMp = new Dictionary<string, int>();

            int maxMp = 200;
            int maxHp = 100;

            for (int i = 0; i < n; i++)
            {
                string[] heroes = Console.ReadLine().Split();

                string heroName = heroes[0];
                int HP = int.Parse(heroes[1]);
                int MP = int.Parse(heroes[2]);


                heroHp.Add(heroName, HP);
                heroMp.Add(heroName, MP);

            }
            string command = Console.ReadLine();

            while (command != "End")
            {

                string[] parts = command.Split(" - ");
                string operation = parts[0];
                string heroName = parts[1];

                if (operation == "CastSpell")
                {
                    int mp = int.Parse(parts[2]);
                    string spellName = parts[3];



                    if (mp <= heroMp[heroName])
                    {
                        heroMp[heroName] -= mp;
                        Console.WriteLine($"{heroName} has successfully cast {spellName} and now has {heroMp[heroName]} MP!");
                    }
                    else
                    {

                        Console.WriteLine($"{heroName} does not have enough MP to cast {spellName}!");
                    }


                }
                else if (operation == "TakeDamage")
                {
                    int damage = int.Parse(parts[2]);
                    string attacker = parts[3];


                    if (heroHp[heroName] - damage > 0)
                    {
                        heroHp[heroName] -= damage;
                        Console.WriteLine($"{heroName} was hit for {damage} HP by {attacker} and now has {heroHp[heroName]} HP left!");
                    }
                    else
                    {
                        heroMp.Remove(heroName);
                        heroHp.Remove(heroName);
                        Console.WriteLine($"{heroName} has been killed by {attacker}!");
                    }


                }
                else if (operation == "Recharge")
                {
                    int amout = int.Parse(parts[2]);

                    int mpBefore = heroMp[heroName];
                    heroMp[heroName] += amout;
                    int mpAfter = heroMp[heroName];

                    if (heroMp[heroName] > maxMp)
                    {
                        heroMp[heroName] = maxMp;
                        Console.WriteLine($"{heroName} recharged for {maxMp - mpBefore} MP!");
                    }
                    else
                    {
                        Console.WriteLine($"{heroName} recharged for {mpAfter - mpBefore} MP!");
                    }


                }
                else if (operation == "Heal")
                {
                    int amout = int.Parse(parts[2]);

                    int hpBefore = heroHp[heroName];
                    heroHp[heroName] += amout;
                    int hpAfter = heroHp[heroName];

                    if (heroHp[heroName] > maxHp)
                    {
                        heroHp[heroName] = maxHp;
                        Console.WriteLine($"{heroName} healed for {maxHp - hpBefore} HP!");
                    }
                    else
                    {
                        Console.WriteLine($"{heroName} healed for {hpAfter - hpBefore} HP!");
                    }


                }
                command = Console.ReadLine();

            }
            Dictionary<string, int> sorted = heroHp
                .OrderByDescending(x => x.Value)
                .ThenBy(x => x.Key)
                .ToDictionary(x => x.Key, x => x.Value);

            foreach (var item in sorted)
            {
                Console.WriteLine($"{item.Key}");
                Console.WriteLine($"  HP: {item.Value}");
                Console.WriteLine($"  MP: {heroMp[item.Key]}");
            }
        }
    }
}
