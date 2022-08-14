//
//  ContentView.swift
//  HangmanCoursework-K1906309
//
//  Created by Admin on 05/03/2022.
//

import SwiftUI


struct ContentView: View {
    let guesses: Int = 10 //guesses available to player
    @State var guessesLeft: Int = 0 //status of available guesses left for current game
    
    let availableWords: [String] = ["house", "teacher", "pen", "aquarium", "telephone", "computer", "nature"]//word of current game, wrapped in ? because no word is chosen when created.
    let alphabet: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"] //used to ensure the users entry is within this list, and nothing else.
    @State var availableLetters: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]//used to check against the selected word.
    
    @State var selectedWord: String?
    @State var entry: String = "" //used for users Entry.
    @State var lastEntry: String = "" //used to check validity of entry
    
    @State var lostCount: Int = 0
    @State var winCount: Int = 0
    
    var body: some View {
        NavigationView { //used to show the "Hangman game" title.
            VStack { //aligns all views following vertically
                if selectedWord != nil { //if the word exists, then show the "keyboard" and the amount of letters left
                    Spacer()
                    HStack(spacing: 4) {
                        Text("\(guessesLeft)")
                            .font(.largeTitle)
                            .bold()
                        Text("GUESSES LEFT!")
                            .bold()
                            .offset(y: 4)
                        Spacer()
                    }
                    .padding(.leading)
                    Spacer()
                    HStack {
                        if selectedWord != nil {
                            ForEach(0 ..< selectedWord!.count, id: \.self) { letterIndex in //iterates through all selectedWord characters. id: \.self is used so that each iteration can be uniquely identified.
                                ZStack {
                                    if availableLetters.firstIndex(of: String(Array(selectedWord!)[letterIndex])) == nil { //this is used to check that the User hasn't already found the word, as it checks whether the letters of the selectedWord is within the availableLetters word.
                                        Text(String(Array(selectedWord!)[letterIndex])) //If a letter has been found already, then it will display this on to the screen.
                                    }
                                    Text("_") //for the count of the selected word, it will display '_' for each letter in the word.
                                        .offset(y: 2)
                                }
                                .font(.largeTitle)
                                .minimumScaleFactor(0.5) //allows even longer words to still fit on the screen
                                .lineLimit(1)
                            }
                        }
                    }
                    Spacer()
                    TextField("Enter your guess here", text: $entry)
                        .disableAutocorrection(true)
                        .onChange(of: entry) {_ in
                            entry = entry.lowercased() //force all the entries to be lowercased.
                            
                            //make sure letters aren't used multiple times
                            var array: Array = Array(entry) //adds all entries to an array.
                            array = Array(NSOrderedSet(array: array)) as! [Character] //Stores all of the entries within here in the order they were entered so the user cant re-input the same letter, and they can see what letters have been used.
                            entry = String(array) //sets entry to the contents of this Array so the user can see what has already been entered.
                            
                            //This for loop ensures that letters input are only those in the alphabet array, to ensure no other characters can be entered.
                            for x in entry {
                                if alphabet.firstIndex(of: String(x)) == nil {
                                    entry = lastEntry
                                }
                            }

                            if lastEntry.count >= entry.count {//stops delete button in keyboard
                                entry = lastEntry
                            }
                            
                            else if selectedWord != nil && entry.count > 0 { //check to only show keyboard if first game has started
                                if alphabet.firstIndex(of: String(entry.last!)) != nil {
                                    availableLetters[alphabet.firstIndex(of: String(entry.last!))!] = "USED"
                                }
                                if selectedWord!.firstIndex(of: entry.last!) == nil { // if the user enters a letter which is NOT in the selected word, they will lose a guess.
                                    guessesLeft -= 1
                                    if guessesLeft == 0 { //If they havve lost all of their guesses, then the game will restart.
                                        lostCount += 1
                                        guessesLeft = guesses
                                        resetGame()
                                    }
                                }
                            }
                            lastEntry = entry
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        resetGame()
                    }) {
                        Text("New game")
                            .bold()
                    }
                }
            }
            .navigationTitle("Hangman game")
        }
        .onChange(of: availableLetters) {_ in //once a new letter has been used, the following code checks if the word is complete.
            if selectedWord != nil {
                var letterCount: Int = 0
                for letter in 0 ..< selectedWord!.count {
                    if availableLetters.firstIndex(of: String(Array(selectedWord!)[letter])) == nil {
                        letterCount += 1
                    }
                }
                if letterCount >= selectedWord!.count {
                    winCount += 1
                    resetGame()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    func resetGame() -> Void {
        var possibleNewWord = availableWords[Int.random(in: 0 ..< availableWords.count)]
        while possibleNewWord == selectedWord { //this while loop checks that the new word is not the same as the old one
            possibleNewWord = availableWords[Int.random(in: 0 ..< availableWords.count)]
        }
        selectedWord = possibleNewWord
        guessesLeft = guesses
        availableLetters = alphabet
        lastEntry = ""
        entry = ""
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
