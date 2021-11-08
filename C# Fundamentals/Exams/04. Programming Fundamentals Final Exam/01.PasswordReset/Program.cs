using System;

namespace _01.PasswordReset
{
    class Program
    {
        static void Main(string[] args)
        {
            string password = Console.ReadLine();
            string command = Console.ReadLine();

            while (command != "Done")
            {
                string[] parts = command.Split();

                switch (parts[0])
                {
                    case "TakeOdd":
                        string newPassword = string.Empty;
                        for (int i = 0; i < password.Length; i++)
                        {

                            if (i % 2 == 1)
                            {
                                newPassword += password[i];
                            }
                        }
                        password = newPassword;
                        Console.WriteLine(password);
                        break;

                    case "Cut":
                        int index = int.Parse(parts[1]);
                        int lenght = int.Parse(parts[2]);
                        password = password.Remove(index, lenght);
                        Console.WriteLine(password);
                        break;

                    case "Substitute":
                        string substring = parts[1];
                        string substitude = parts[2];
                        if (password.Contains(substring))
                        {
                            password = password.Replace(substring, substitude);
                            Console.WriteLine(password);
                        }
                        else
                        {
                            Console.WriteLine("Nothing to replace!");
                        }

                        break;
                }

                command = Console.ReadLine();
            }
            Console.WriteLine($"Your password is: { password}");
        }
    }
}
