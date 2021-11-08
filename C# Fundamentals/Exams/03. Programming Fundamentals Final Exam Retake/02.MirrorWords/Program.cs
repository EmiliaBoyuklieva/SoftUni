using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace _02.MirrorWords
{
    class Program
    {
        static void Main(string[] args)
        {
            string text = Console.ReadLine();
            
            Regex regex = new Regex(@"([#|@])(?<word>[A-Za-z]{3,})\1{2}(?<mirrorWord>[A-Za-z]{3,})\1");

            List<string> validWords = new List<string>();

            MatchCollection match = regex.Matches(text);

            string word = string.Empty;
            string mirrorWordReversed = string.Empty;
            string mirrorWord = string.Empty;
       
            int counter = 0;

            foreach (Match item in match)
            {
                word =  item.Groups["word"].Value;
                mirrorWord = item.Groups["mirrorWord"].Value;

                counter++;

                mirrorWordReversed = string.Concat(word.Reverse());

                if(mirrorWord == mirrorWordReversed)
                {

                    validWords.Add($"{word} <=> {mirrorWord}");
                
                } 
            }
            if (match.Count == 0)
            {
                
                Console.WriteLine("No word pairs found!");

            }
           else
            {
                Console.WriteLine($"{counter} word pairs found!");
            }

            if (validWords.Count == 0)
            {
                Console.WriteLine("No mirror words!");
            }
            else
            {
                Console.WriteLine($"The mirror words are:");

                Console.WriteLine( string.Join(", ", validWords));
            }
        }
    }
}
