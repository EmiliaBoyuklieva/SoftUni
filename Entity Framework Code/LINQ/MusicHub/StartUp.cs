namespace MusicHub
{
    using System;
    using System.Collections.Generic;
    using System.Globalization;
    using System.Linq;
    using System.Text;
    using Data;
    using Initializer;

    public class StartUp
    {
        public static void Main(string[] args)
        {
            MusicHubDbContext context =  new MusicHubDbContext();

            DbInitializer.ResetDatabase(context);

            //string result = ExportAlbumsInfo(context, 9);
            string result = ExportSongsAboveDuration(context, 4);
            Console.WriteLine(result);
        }

        //02.All Albums Produced by Given Producer
        public static string ExportAlbumsInfo(MusicHubDbContext context, int producerId)
        {
            StringBuilder sb = new StringBuilder();
            
            int counter = 1;

            var albums = context
                .Producers
                .FirstOrDefault(p=>p.Id==producerId)
                .Albums
                .OrderByDescending(a => a.Price)
                .Select(p=> new {
                    p.Name,
                    p.ReleaseDate,
                    producer = p.Producer.Name,
                    p.Songs,
                    albumPrice = p.Price
                })
               
               .ToList();

            foreach (var item in albums)
            {
                sb.Append($"-AlbumName: {item.Name}\r\n");
                sb.Append($"-ReleaseDate: {item.ReleaseDate.ToString("MM/dd/yyyy",CultureInfo.InvariantCulture)}\r\n");
                sb.Append($"-ProducerName: {item.producer}\r\n");
                sb.Append($"-Songs:\r\n");

                var songs = item
                    .Songs
                    .OrderByDescending(s => s.Name)
                    .ThenBy(w => w.Writer.Name);

                foreach (var song in songs)
                {

                    sb.Append($"---#{counter}\r\n");
                    sb.Append($"---SongName: {song.Name}\r\n");
                    sb.Append($"---Price: {song.Price:f2}\r\n");
                    sb.Append($"---Writer: {song.Writer.Name}\r\n");

                    counter++;
                   
                }
                
                sb.Append($"-AlbumPrice: {item.albumPrice:f2}\r\n");
                counter = 1;
            }
          

             return sb.ToString().TrimEnd();
                
        }

        //03.Songs Above Given Duration
        public static string ExportSongsAboveDuration(MusicHubDbContext context, int duration)
        {
            StringBuilder sb = new StringBuilder();

            int counter = 1;

            var songs = context
                .Songs
                .Where(s => s.Duration > new TimeSpan(0,0,0, duration))
                .OrderBy(s=>s.Name)
                .ThenBy(s=>s.Writer)
                .Select(s=> new
                {
                   s.Name,
                   performerFirstName = s.SongPerformers
                                .FirstOrDefault().Performer.FirstName,
                   performerLastName = s.SongPerformers
                                .FirstOrDefault().Performer.LastName,
                   writer = s.Writer.Name,
                   producer = s.Album.Producer.Name,
                   s.Duration

                })

               .ToList();

            foreach (var song in songs)
            {
               
                    sb.AppendLine($"-Song #{counter}");
                    sb.AppendLine($"---SongName: {song.Name}");
                    sb.AppendLine($"---Writer: {song.writer}");

                if(song.performerFirstName == null && song.performerLastName== null)
                {
                    sb.AppendLine($"---Performer: ");
                }
                else
                {
                    sb.AppendLine($"---Performer: {song.performerFirstName} {song.performerLastName}");
                }
                
             
                sb.AppendLine($"---AlbumProducer: {song.producer}");
                sb.AppendLine($"---Duration: {song.Duration.ToString("c",CultureInfo.InvariantCulture)}");
                counter++;
            }


            return sb.ToString().TrimEnd();
        }
    }
}
