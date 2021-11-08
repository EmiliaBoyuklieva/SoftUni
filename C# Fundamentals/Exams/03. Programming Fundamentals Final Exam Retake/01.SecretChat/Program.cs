using System;
using System.Linq;
using System.Text;

namespace _03.ProgrammingFundamentalsFinalExamRetake
{
    class Program
    {
        static void Main(string[] args)
        {
            string message = Console.ReadLine();
            string command = Console.ReadLine();

            while(command !="Reveal")
            {
                string[] parts = command.Split(":|:");
                string operation = parts[0];
                switch (operation)
                {
                    case "InsertSpace":

                        int index = int.Parse(parts[1]);
                        message = message.Insert(index, " ");
                        Console.WriteLine(message);
                        break;


                    case "Reverse":
                        string substring = parts[1];

                        if (message.Contains(substring))
                        {
                            int indexOf = message.IndexOf(substring);
                            message = message.Remove(indexOf, substring.Length);
                            substring = string.Concat(substring.Reverse());
                            message += string.Concat(substring);
                            Console.WriteLine(message);

                        }
                        else
                        {
                            Console.WriteLine("error");
                            
                        }
                        break;

                    case "ChangeAll":
                        string substringg = parts[1];
                        string replacement = parts[2];
                        message = message.Replace(substringg, replacement);
                        Console.WriteLine(message);

                        break;
                }



                command = Console.ReadLine();
            }
            Console.WriteLine($"You have a new text message: {message}");
        }
    
    }
}
