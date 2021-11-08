using System;
using System.Collections.Generic;
using System.Linq;

namespace _08.CompanyUsers
{
    class Program
    {
        static void Main(string[] args)
        {
            SortedDictionary<string, List<string>> companyName =
                new SortedDictionary<string, List<string>>();

            string[] company = Console.ReadLine().Split(" -> ");

            while (company[0] != "End")
            {
                string cmpName = company[0];
                string id = company[1];

                if (companyName.ContainsKey(cmpName))
                {
                    companyName[cmpName].Add(id);
                }
                else
                {
                    companyName.Add(cmpName, new List<string>());
                    companyName[cmpName].Add(id);
                }

                company = Console.ReadLine().Split(" -> ");
            }

            foreach (var item in companyName)
            {
                Console.WriteLine(item.Key);

                List<string> uniqueEmployee = item.Value.Distinct().ToList();

                foreach (var employee in uniqueEmployee)
                {
                    Console.WriteLine($"-- {employee}");
                }
            }
        }
    }
}
