with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with stacks;
with queues;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Unbounded.Text_IO; use Ada.Strings.Unbounded.Text_IO;
with Ada.Strings; use Ada.Strings;
with Ada.Text_IO; use Ada.Text_IO;

procedure tournament is

	subtype ageRange is Natural range 3..99;
	subtype skillRange is Natural range 1..999;
	
	type contestant is record
		name: Unbounded_String;
		skill: skillRange;
		age: ageRange;
		wins: Natural;
		losses: Natural;
		arrivalPosition: Natural;
		place: Natural;
	end record;

	procedure print(c: contestant) is
	begin -- print
		put(c.place, 4);
		put(c.age, 6);
		put(c.skill, 6);
		put(c.wins, 5);
		put(c.losses, 6);
		put("   ");
		put(c.name);
		new_line;
	end print;

	package stackpkg is new stacks(contestant, print);
	use stackpkg;

	package queuepkg is new queues(contestant, print);
	use queuepkg;

	function areScoresEqual(c1: contestant; c2: contestant) return boolean is
	begin -- areScoresEqual
		return c1.skill = c2.skill;
	end areScoresEqual;

	function whichScoreIsHigher(c1: contestant; c2: contestant) return contestant is
	begin -- whichScoreIsHigher
		if c1.skill > c2.skill then
			return c1;
		else
			return c2;
		end if;
	end whichScoreIsHigher;

	function whichScoreIsLower(c1: contestant; c2: contestant) return contestant is
	begin -- whichScoreIsLower
		if c1.skill > c2.skill then
			return c2;
		else
			return c1;
		end if;
	end whichScoreIsLower;

	function areAgesTheSame(c1: contestant; c2: contestant) return boolean is
	begin -- areAgesTheSame
		return c1.age = c2.age;
	end areAgesTheSame;

	function whoIsOlder(c1: contestant; c2: contestant) return contestant is
	begin -- whoIsOlder
		if c1.age > c2.age then
			return c1;
		else
			return c2;
		end if;
	end whoIsOlder;

	function whoIsYounger(c1: contestant; c2: contestant) return contestant is
	begin -- whoIsYounger
		if c1.age > c2.age then
			return c2;
		else
			return c1;
		end if;
	end whoIsYounger;

	function areNumberOfWinsEqual(c1: contestant; c2: contestant) return boolean is
	begin -- areNumberOfWinsEqual
		return c1.wins = c2.wins;
	end areNumberOfWinsEqual;

	function whoHasMoreWins(c1: contestant; c2: contestant) return contestant is
	begin -- whoHasMoreWins
		if c1.wins > c2.wins then
			return c1;
		else
			return c2;
		end if;
	end whoHasMoreWins;

	function whoHasFewerWins(c1: contestant; c2: contestant) return contestant is
	begin -- whoHasFewerWins
		if c1.wins > c2.wins then
			return c2;
		else
			return c1;
		end if;
	end whoHasFewerWins;

	function areNumberOfLossesEqual(c1: contestant; c2: contestant) return boolean is
	begin -- areNumberOfLossesEqual
		return c1.losses = c2.losses;
	end areNumberOfLossesEqual;

	function whoHasFewerLosses(c1: contestant; c2: contestant) return contestant is
	begin -- whoHasFewerLosses
		if c1.losses < c2.losses then
			return c1;
		else
			return c2;
		end if;
	end whoHasFewerLosses;

	function whoHasMoreLosses(c1: contestant; c2: contestant) return contestant is
	begin -- whoHasMoreLosses
		if c1.losses < c2.losses then
			return c2;
		else
			return c1;
		end if;
	end whoHasMoreLosses;

	function whoArrivedFirstInLine(c1: contestant; c2: contestant) return contestant is
	begin -- whoArrivedFirstInLine
		if c1.arrivalPosition < c2.arrivalPosition then
			return c1;
		else
			return c2;
		end if;
	end whoArrivedFirstInLine;

	function whoArrivedLaterInLine(c1: contestant; c2: contestant) return contestant is
	begin -- whoArrivedLaterInLine
		if c1.arrivalPosition < c2.arrivalPosition then
			return c2;
		else
			return c1;
		end if;
	end whoArrivedLaterInLine;

	procedure whoIsTheWinner(c1, c2: in contestant; winner, loser: out contestant) is
	begin -- whoIsTheWinner
		if not areScoresEqual(c1, c2) then
			winner := whichScoreIsHigher(c1, c2);
			loser := whichScoreIsLower(c1, c2);
		elsif not areAgesTheSame(c1, c2) then
			winner := whoIsOlder(c1, c2);
			loser := whoIsYounger(c1, c2);
		elsif not areNumberOfWinsEqual(c1, c2) then
			winner := whoHasMoreWins(c1, c2);
			loser := whoHasFewerWins(c1, c2);
		elsif not areNumberOfLossesEqual(c1, c2) then
			winner := whoHasFewerLosses(c1, c2);
			loser := whoHasMoreLosses(c1, c2);
		else
			winner := whoArrivedFirstInLine(c1, c2);
			loser := whoArrivedLaterInLine(c1, c2);
		end if;
	end whoIsTheWinner;

	procedure readInput(playerQ: in out queue; contestantCount: out Natural) is
		tempName: Unbounded_String;
		tempSkill: skillRange;
		tempAge: ageRange;
		tempContestant: contestant;
	begin -- readInput
		contestantCount := 0;
		while not end_of_file loop
			get_line(tempName);
			trim(tempName, both);
			get(tempSkill);
			get(tempAge);
			skip_line;

			contestantCount := contestantCount + 1;

			tempContestant.name := tempName;
			tempContestant.skill := tempSkill;
			tempContestant.age := tempAge;
			tempContestant.wins := 0;
			tempContestant.losses := 0;
			tempContestant.place := 0;
			tempContestant.arrivalPosition := contestantCount;

			enqueue(tempContestant, playerQ);
		end loop;
	end readInput;

	procedure smash(cQ: in out queue; lQ: in out queue; wS: in out stack; count: in Natural) is
		winner: contestant;
		loser: contestant;

		currentC1: contestant;
		currentC2: contestant;
	begin -- smash
		while not is_empty(cQ) loop
			currentC1 := front(cQ);
			dequeue(cQ);
			if not is_empty(cQ) then
				currentC2 := front(cQ);
				dequeue(cQ);
				whoIsTheWinner(currentC1, currentC2, winner, loser);
				winner.wins := winner.wins + 1;
				loser.losses := loser.losses + 1;
				enqueue(winner, cQ);
				enqueue(loser, lQ);
			else
				winner := currentC1;
				winner.place := count;
				push(winner, wS);
			end if;
		end loop;
	end smash;

	procedure resetMatches(cQ, lQ: in out queue) is
	begin -- resetMatches
		while not is_empty(lQ) loop
			enqueue(front(lQ), cQ);
			dequeue(lQ);
		end loop;
	end resetMatches;

	procedure runFullGame(cQ, lQ: in out queue; wS: in out stack; count: in Natural) is
		counter: Natural;
	begin -- runFullGame
		counter := 1;
		for round in 0..count loop
			smash(cQ, lQ, wS, counter);
			resetMatches(cQ, lQ);
			counter := counter + 1;
		end loop;
	end runFullGame;

	procedure printOutput(wS: in stack) is
	begin -- printOutput
		put("Number  Age Skill Wins Losses Name");
		new_line;
		print(wS);
	end printOutput;

	winners: stack;
	competingQ: queue;
	losersQ: queue;

	contestantCount: Natural;
begin -- Tournament
	readInput(competingQ, contestantCount);
	runFullGame(competingQ, losersQ, winners, contestantCount);
	printOutput(winners);
end tournament;