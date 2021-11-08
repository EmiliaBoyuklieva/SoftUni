using System;
using System.Collections.Generic;
using System.Linq;

namespace _07.StudentAcademy
{
    class Program
    {
        static void Main(string[] args)
        {
            int n = int.Parse(Console.ReadLine());

            Dictionary<string, List<double>> courses = new Dictionary<string, List<double>>();

            for (int i = 0; i < n; i++)
            {
                string studentName = Console.ReadLine();
                double grades = double.Parse(Console.ReadLine());

                if (!courses.ContainsKey(studentName))
                {
                    courses.Add(studentName, new List<double>());
                    courses[studentName].Add(grades);
                }
                else
                {
                    courses[studentName].Add(grades);
                }
            }

            Dictionary<string, List<double>> sortedCourse = 
                courses.Where(s => s.Value.Average() >= 4.50)
                .OrderByDescending(x => x.Value.Average())
                .ToDictionary(x => x.Key, x => x.Value);

            foreach (var item in sortedCourse)
            {
                Console.WriteLine($"{item.Key} -> {item.Value.Average():f2}");
            }
        }
    }
}
