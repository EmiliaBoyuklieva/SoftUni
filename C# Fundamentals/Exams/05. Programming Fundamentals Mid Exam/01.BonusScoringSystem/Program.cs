using System;

namespace _01.BonusScoringSystem
{
    class Program
    {
        static void Main(string[] args)
        {
            int studentsCount = int.Parse(Console.ReadLine());
            int lecturesCount = int.Parse(Console.ReadLine());
            int bonus = int.Parse(Console.ReadLine());

            double totalBonus = 0;
            int currentAttendenes = 0;
            double currentStudent = 0;

            for (int i = 0; i < studentsCount; i++)
            {
                int attendenes = int.Parse(Console.ReadLine());
                totalBonus = (attendenes * 1.0 / lecturesCount) * (5 + bonus);


                if (totalBonus > currentStudent)
                {
                    currentStudent = totalBonus;
                    currentAttendenes = attendenes;
                }

            }
            Console.WriteLine($"Max Bonus: {Math.Round(currentStudent)}.");
            Console.WriteLine($"The student has attended {currentAttendenes} lectures.");
        }
    }
}
