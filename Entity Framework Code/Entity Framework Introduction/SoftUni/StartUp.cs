using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Internal;
using SoftUni.Data;
using SoftUni.Models;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;

namespace SoftUni
{
    public class StartUp
    {
       public static void Main(string[] args)
        {
            SoftUniContext db = new SoftUniContext();

            var results = DeleteProjectById(db);
            Console.WriteLine(results);

        }

        //03. Employees Full Information
        public static string GetEmployeesFullInformation(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var fullInfo = context
                .Employees
                .OrderBy(e=> e.EmployeeId)
                .Select( e => 
                new {
                    e.FirstName,
                    e.LastName,
                    e.MiddleName,
                    e.JobTitle,
                    e.Salary
                })
                .ToList();

            foreach (var employee in fullInfo)
            {
                sb.AppendLine($"{ employee.FirstName} { employee.LastName} { employee.MiddleName} { employee.JobTitle} { employee.Salary:f2}");
            }

            return sb.ToString().TrimEnd();
        }

        //04. Employees with Salary Over 50 000
        public static string GetEmployeesWithSalaryOver50000(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var employees = context
                .Employees
                .Where(e=>e.Salary > 50000)
                .OrderBy(e => e.FirstName)
                .Select(e =>
               new {
                   e.FirstName,
                   e.Salary
                 
               })
                .ToList();

            foreach (var employee in employees)
            {
                sb.AppendLine($"{ employee.FirstName} - { employee.Salary:f2}");
            }

            return sb.ToString().TrimEnd();
        }

        //05. Employees from Research and Development
        public static string GetEmployeesFromResearchAndDevelopment(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var employeesRD = context
                .Employees
                .Where(e => e.Department.Name == "Research and Development")
                .OrderBy(e => e.Salary)
                .ThenByDescending(e => e.FirstName)
                .Select(e =>
               new {
                   e.FirstName,
                   e.LastName,
                   e.Department.Name,
                   e.Salary
               })
                .ToList();

            foreach (var employee in employeesRD)
            {
               
                sb.AppendLine($"{ employee.FirstName} { employee.LastName} from {employee.Name} - ${ employee.Salary:f2}");
            }

            return sb.ToString().TrimEnd();
        }

        //06. Adding a New Address and Updating Employee
        public static string AddNewAddressToEmployee(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var newAdress = new Address()
            {
                AddressText = "Vitoshka 15",
                TownId = 4
            };

            context.Addresses.Add(newAdress);

            var employeeNakov = context
                .Employees
                .First(e => e.LastName == "Nakov");

            employeeNakov.Address = newAdress;
            context.SaveChanges();

            var adresses = context
                .Employees   
                .OrderByDescending(e => e.AddressId)
                .Select(e => e.Address.AddressText)
                .Take(10)
                .ToList();

            foreach (var adress in adresses)
            {

                sb.AppendLine($"{adress}");
            }

            return sb.ToString().TrimEnd();
        }

        //07. Employees and Projects
        public static string GetEmployeesInPeriod(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var employees = context
               .Employees
               .Include(e=>e.EmployeesProjects)
               .ThenInclude(p=>p.Project)
               .Where(e => e.EmployeesProjects
               .Any(p=>p.Project.StartDate.Year >= 2001 && p.Project.StartDate.Year <= 2003))
               .Select(x=> new 
               {   x.FirstName,
                   x.LastName,
                   managerName = x.Manager.FirstName,
                   managerLNmae = x.Manager.LastName,
                   Project = x.EmployeesProjects
                                    .Select
                                    ( x => new
                                       {
                                        x.Project.Name,
                                        x.Project.StartDate,
                                        x.Project.EndDate
                                        }
                                    )
               })
               .Take(10)
               .ToList();
              

            foreach (var employee in employees)
            {
                sb.AppendLine($"{employee.FirstName} {employee.LastName} - Manager: {employee.managerName} {employee.managerLNmae}");

                foreach (var item in employee.Project)
                {


                    if (!item.EndDate.HasValue)
                    {

                        var startData = item.StartDate.ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture);

                        sb.AppendLine($"--{item.Name} - {startData} - not finished");
                    }
                    else
                    {

                        var endData = item.EndDate.Value.ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture);

                        var startData = item.StartDate.ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture);

                        sb.AppendLine($"--{item.Name} - {startData} - {endData}");
                    }

                }

            }

            return sb.ToString().TrimEnd();
        
    }

        //08. Addresses by Town
        public static string GetAddressesByTown(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var adresses = context
               .Addresses
               .Include(t=>t.Town)
               .Include(e=>e.Employees)
               .OrderByDescending(x=>x.Employees.Count())
               .ThenBy(t=>t.Town.Name)
               .ThenBy(a=>a.AddressText)
               .Take(10)
               .ToList();

            foreach (var adress in adresses)
            {
                sb.AppendLine($"{adress.AddressText}, {adress.Town.Name} - {adress.Employees.Count()} employees");

            }

            return sb.ToString().TrimEnd();
        }

        //09. Employee 147
        public static string GetEmployee147(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var employee147 = context
               .Employees
               .Include(ep=>ep.EmployeesProjects)
               .ThenInclude(p=>p.Project)
               .Where(e => e.EmployeeId == 147)
               .Select(e => new
               {
                   e.FirstName,
                   e.LastName,
                   e.JobTitle,
                   e.EmployeesProjects
               })
               .First();


            sb.AppendLine($"{employee147.FirstName} {employee147.LastName} - {employee147.JobTitle}");

            var ordered = employee147.EmployeesProjects
                .OrderBy(ep => ep.Project.Name);

            foreach (var project in ordered)
            {
                sb.AppendLine($"{project.Project.Name}");
            }

            return sb.ToString().TrimEnd();
        }

        //10. Departments with More Than 5 Employees
        public static string GetDepartmentsWithMoreThan5Employees(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var departments = context
               .Departments
               .Where(e => e.Employees.Count() > 5)
               .Select(d => new 
               {
                   d.Name, 
                   d.Manager, 
                   d.Employees 
               })
               .OrderBy(e => e.Employees.Count())
               .ThenBy(d => d.Name)
               .ToList();

            foreach (var department in departments)
            {
                sb.AppendLine($"{department.Name} - {department.Manager.FirstName} {department.Manager.LastName}");

                var ordered = department.Employees
                    .OrderBy(e => e.FirstName)
                    .ThenBy(e => e.LastName);

                foreach (var employee in ordered)
                {
                    sb.AppendLine($"{employee.FirstName} {employee.LastName} - {employee.JobTitle}");
                }
            }

            return sb.ToString().TrimEnd();
        }

        //11. Find Latest 10 Projects
        public static string GetLatestProjects(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var projects = context
                .Projects
                .OrderByDescending(p => p.StartDate)
                .Select( x=> new
                {
                    x.Name,
                    x.Description,
                    x.StartDate
                })
                .Take(10);


            var ordered = projects
                .OrderBy(n => n.Name);

            foreach (var item in ordered)
            {
                sb.AppendLine(item.Name);
                sb.AppendLine(item.Description);
                sb.AppendLine(item.StartDate.ToString("M/d/yyyy h:mm:ss tt", CultureInfo.InvariantCulture));
            }

            return sb.ToString().TrimEnd();
        }

        //12. Increase Salaries
        public static string IncreaseSalaries(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var employees = context
                .Employees
                .Where(d => d.Department.Name == "Engineering" 
                         || d.Department.Name == "Tool Design"
                         || d.Department.Name == "Marketing"
                         || d.Department.Name == "Information Services")
                .OrderBy(n=>n.FirstName)
                .ThenBy(n=>n.LastName)
                .ToList();

            foreach (var employee in employees)
            {
                employee.Salary *= 1.12m;
                sb.AppendLine($"{employee.FirstName} {employee.LastName} (${employee.Salary:f2})");
            }


            return sb.ToString().TrimEnd();
        }

        //13. Find Employees by First Name Starting With Sa
        public static string GetEmployeesByFirstNameStartingWithSa(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var employeesSa = context
                .Employees
                .Where(n=>n.FirstName.StartsWith("Sa"))
                .OrderBy(n => n.FirstName)
                .ThenBy(n => n.LastName)
                .ToList();

            foreach (var employee in employeesSa)
            {
                
                sb.AppendLine($"{employee.FirstName} {employee.LastName} - {employee.JobTitle} - (${employee.Salary:f2})");
            }


            return sb.ToString().TrimEnd();
        }

        //14. Delete Project by Id
        public static string DeleteProjectById(SoftUniContext context)
        {
            StringBuilder sb = new StringBuilder();

            var project = context.Projects.Find(2);

            var projectInEP = context
                .EmployeesProjects
                .Where(p=>p.ProjectId == 2);

            context.EmployeesProjects.RemoveRange(projectInEP);
            context.Projects.Remove(project);

            context.SaveChanges();

            var currProject = context
                .Projects
                .Take(10);

            foreach (var item in currProject)
            {
                sb.AppendLine(item.Name);
            }

            return sb.ToString().TrimEnd();

        }
        //15. Remove Town
        public static string RemoveTown(SoftUniContext context)
        {
            var employeesAddresses = context.Employees
               .Include(e => e.Address)
               .Where(e => e.Address.Town.Name == "Seattle")
               .ToList();

            foreach (var employee in employeesAddresses)
            {
                employee.AddressId = null;
            }

            context.SaveChanges();

            var addresses = context
                .Addresses
                .Where(a => a.Town.Name == "Seattle")
                .ToList();

            context.Addresses.RemoveRange(addresses);

            context.SaveChanges();

            var townToRemove = context
                .Towns
                .FirstOrDefault(t => t.Name == "Seattle");

            context.Towns.Remove(townToRemove);

            context.SaveChanges();

            var deleted = $"{addresses.Count()} addresses in Seattle were deleted";
            return deleted;
        }
    }


}

