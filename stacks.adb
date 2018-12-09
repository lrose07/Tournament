with Unchecked_Deallocation;

package body stacks is

	procedure free is new Unchecked_Deallocation(StackNode, Stack);

	function is_Empty(S: Stack) return Boolean is
	begin
		return S = null;
	end is_Empty;

	function is_Full(S: Stack) return Boolean is
	begin
		return false;
	end is_Full;

	procedure push(Item: ItemType; S : in out Stack) is
	begin
		S := new StackNode'(Item, S);
	end push;

	procedure pop(S : in out Stack) is
		temp: Stack := S;
	begin
		if not is_Empty(S) then
			S := S.next;
			free(temp);
		else
			raise Stack_Empty;
		end if;
	end pop;

	function top(S: Stack) return ItemType is
	begin
		if not is_Empty(S) then
			return S.Item;
		else
			raise Stack_Empty;
		end if;
	end top;

	procedure print(S : in Stack) is
		temp: Stack := S;
	begin
		while temp /= null loop
			print(temp.all.Item);
			temp := temp.next;
		end loop;
	end print;
end stacks;