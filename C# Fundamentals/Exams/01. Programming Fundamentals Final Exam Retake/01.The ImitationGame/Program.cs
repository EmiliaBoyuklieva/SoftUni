using System;

namespace Programming_Fundamentals_Final_Exam_Retake_15._08._2020
{
    class Program
    {
        static void Main(string[] args)
        {
            string message = Console.ReadLine();
            string command = Console.ReadLine();


            while(command!= "Decode")
            {
                string[] parts = command.Split("|");
                string operation = parts[0];
                switch (operation)
                {
                    case "Move":

                        int n = int.Parse(parts[1]);
                        string remove = message.Substring(0, n);
                        message = message.Substring(n) + remove;
                    
                        break;
                    case "Insert":
                        int index = int.Parse(parts[1]);
                        string value = parts[2];
                        message = message.Insert(index, value);
                break;
                    case "ChangeAll":
                        string substring = parts[1];
                        string replacement = parts[2];
                        message = message.Replace(substring, replacement);
                        break;
                }


                command = Console.ReadLine();
            }
            Console.WriteLine($"The decrypted message is: {message}");
        }
    }
}
