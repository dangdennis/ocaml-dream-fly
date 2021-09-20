-- Specifically required as for Dream's session middleware
create table if not exists dream_session (
  id text primary key,
  label text not null,
  expires_at real not null,
  payload text not null
);

create table if not exists comments (
  id serial primary key,
  text text not null
);

create table if not exists public.users (
    id int primary key -- slack user id
    -- should we have a global id too?
);

create table if not exists organizations (
    id int primary key -- slack organization id
);

-- create three default inboxes for every new user 
create table if not exists inboxes (
    id serial primary key,
    user_id int references users(id) not null,
    name text not null,
    priority_order int not null,

    unique(user_id, priority_order)
);

drop function if exists public.handle_new_user cascade;
create or replace function public.handle_new_user()
 returns trigger
 language plpgsql
 security definer
as $function$
begin
  insert into inboxes(user_id, name, priority_order)
  values 
    (new.id, 'next hour', 1),
    (new.id, 'end of day', 2),
    (new.id, 'end of week', 3);
  return new;
end;
$function$;


drop trigger if exists new_inboxes_on_user_insert on inboxes;
create trigger new_inboxes_on_user_insert
  after insert on public.users
  for each row
  execute procedure public.handle_new_user();