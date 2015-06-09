#/Cryptologist Bruce Schneier designed the hand cipher "Solitaire" for Neal Stephenson's
# book "Cryptonomicon". Created to be the first truly secure hand cipher, 
# Solitaire requires only a deck of cards for the encryption and decryption of messages.
#
# While it's true that Solitaire is easily completed by hand given ample time, 
# using a computer is much quicker and easier. Because of that, Solitaire conversion 
# routines are available in many languages, though I've not yet run across one in Ruby.
#
# This week's quiz is to write a Ruby script that does the encryption and decryption 
# of messages using the Solitaire cipher.
 class Encrypter
      def initialize(keystream)
        @keystream = keystream
      end

      def sanitize(s)
        s = s.upcase
        s = s.gsub(/[^A-Z]/, "")
        s = s + "X" * ((5 - s.size % 5) % 5)
        out = ""
        (s.size / 5).times {|i| out << s[i*5,5] << " "}
        return out
      end

      def mod(c)
        return c - 26 if c > 26
        return c + 26 if c < 1
        return c
      end

      def process(s, &combiner)
        s = sanitize(s)
        out = ""
        s.each_byte { |c|
          if c >= ?A and c <= ?Z
            key = @keystream.get
            res = combiner.call(c, key[0])
            out << res.chr
          else
            out << c.chr
          end
        }
        return out
      end

      def encrypt(s)
        return process(s) {|c, key| 64 + mod(c + key - 128)}
      end

      def decrypt(s)
        return process(s) {|c, key| 64 + mod(c -key)}
      end
    end
     
puts "What would you like to do?\n1.) Encrypt\n2.) Decrypt"
input = gets.chomp
  if input == 1 then 
    puts "Type your message for encryption." 
    data = gets.chomp
    return Encrypter.encrypt(data)
  end
   