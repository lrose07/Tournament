with Unchecked_Deallocation;

package body queues is

	procedure free is new Unchecked_Deallocation(QueueNode, QueueNodePointer);

	function  is_Empty(Q: Queue) return Boolean is
	begin
		return Q.front = null;
	end is_Empty;

	function  is_Full(Q: Queue) return Boolean is
	begin
		return false;
	end is_Full;

	function size(Q: Queue) return Natural is
	begin
		return Q.count;
	end size;

	function front(Q: Queue) return ItemType is
	begin
		if is_Empty(Q) then
			raise Queue_Empty;
		else
			return Q.front.Data;
		end if;
	end front;

	procedure enqueue (Item: ItemType; Q: in out Queue) is
		temp: QueueNodePointer := new QueueNode'(item, null);
	begin
		if is_Empty(Q) then
			Q.front := temp;
			Q.back := temp;
		else
			Q.back.next := temp;
			Q.back := temp;
		end if;
		Q.count := Q.count + 1;
	end enqueue;

	procedure dequeue (Q: in out Queue) is
		temp: QueueNodePointer := Q.front;
	begin
		if is_Empty(Q) then
			raise Queue_Empty;
		elsif size(Q) = 1 then
			Q.front := null;
			Q.back := null;
			free(temp);
		else
			Q.front := Q.front.next;
			free(temp);
		end if;
	end dequeue;

	procedure print(Q : in Queue) is
		temp: QueueNodePointer := Q.front;
	begin
		while temp /= null loop
			print(temp.all.data);
			temp := temp.next;
		end loop;
	end print;
end queues;