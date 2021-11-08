using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;

namespace MusicHub.Data.Models
{
    public class Album
    {
        
        public Album()
        {
            this.Songs = new HashSet<Song>();  
          
        }

        [Key]
        public int Id { get; set; }

        [MaxLength(40)]
        [Required]
        public string Name { get; set; }
      
        public DateTime ReleaseDate { get; set; }
        public decimal Price
               => this.Songs.Sum(p => p.Price);
          
        
        [ForeignKey(nameof(Producer))]
        
        public int? ProducerId { get; set; }
        public Producer Producer { get; set; }

        public virtual ICollection<Song> Songs { get; set; }
    }
}
