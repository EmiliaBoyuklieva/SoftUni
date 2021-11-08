using System;
using System.Collections.Generic;
using System.Linq;

namespace _06.Courses
{
    class Program
    {
        static void Main(string[] args)
        {
            Dictionary<string, List<string>> courses = new Dictionary<string, List<string>>();

            string[] course = Console.ReadLine().Split(" : ", StringSplitOptions.RemoveEmptyEntries);

            while (course[0] != "end")
            {
                string courseName = course[0];
                string studentName = course[1];

                if (!courses.ContainsKey(courseName))
                {
                    courses.Add(courseName, new List<string>());
                    courses[courseName].Add(studentName);
                }
                else
                {
                    courses[courseName].Add(studentName);
                }

                course = Console.ReadLine().Split(" : ", StringSplitOptions.RemoveEmptyEntries);
            }

            Dictionary<string, List<string>> sortedCourse = courses.OrderByDescending(x => x.Value.Count)
                .ToDictionary(x => x.Key, x => x.Value);


            foreach (var item in sortedCourse)
            {
                Console.WriteLine($"{item.Key}: {item.Value.Count}");
                item.Value.Sort();

                foreach (var name in item.Value)
                {
                    Console.WriteLine($"-- {name}");
                }
            }
        }
    }
}
