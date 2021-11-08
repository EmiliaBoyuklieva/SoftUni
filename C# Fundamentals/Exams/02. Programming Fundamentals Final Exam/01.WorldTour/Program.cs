using System;

namespace Programming_Fundamentals_Final_Exam_09._08._2020
{
    class Program
    {
        static void Main(string[] args)
        {
            string text = Console.ReadLine();
            string command = Console.ReadLine();

            while(command!= "Travel")
            {
                string[] parts = command.Split(":");
                string operation = parts[0];

                if(operation == "Add Stop")
                {
                    int index = int.Parse(parts[1]);
                    string str = parts[2];

                    if(index>=0 && index<text.Length)
                    {
                       text =  text.Insert(index, str);
                    }
                    Console.WriteLine(text);
                }
                else if (operation== "Remove Stop")
                {
                    int startIndex = int.Parse(parts[1]);
                    int endIndex = int.Parse(parts[2]);

                    if ((startIndex >= 0 && startIndex < text.Length) && (endIndex >= 0 && endIndex < text.Length))
                    {
                        text = text.Remove(startIndex,endIndex - startIndex +1);
                    }
                    Console.WriteLine(text);
                }
                else if (operation == "Switch")
                {
                    string oldString = parts[1];
                    string newString = parts[2];

                    if(text.Contains(oldString))
                    {
                        text = text.Replace(oldString, newString);
                    }
                    Console.WriteLine(text);
                }

                command = Console.ReadLine();
            }
            Console.WriteLine($"Ready for world tour! Planned stops: {text}");
        }
    }
}
