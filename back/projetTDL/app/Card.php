<?php

namespace App;

use DB;
use App\User;

class Card {

  public function __construct($id,$title,$priority,$status,$deadline,$category,$rank,$collaborators){
    $this->id = $id;
    $this->title = $title;
    $this->priority = $priority;
    $this->status = $status;
    $this->deadline = $deadline;
    $this->category = $category;
    $this->rank = $rank;
    $this->collaborators = $collaborators;
  }


  // Create Card + Properties + Logs
  static public function CreateCard ($userID,$title,$priority,$status,$deadline,$category){

    // Insert card into database
    try {
      $resCreateCard = DB::table('cards')->insertGetId(
        ['title' => $title,
         'priority' => $priority,
         'status' => $status,
         'deadline' => $deadline,
         'category' => $category]
      );
    } catch (\Exception $e) {
      return "1";
    }

    // Get max rank from user's card
    try {
      $resGetUserCards = DB::table('properties')
        ->select('rank')
        ->where('users_id_user','=',$userID)
        //->where('cards_id_card','=',$resCreateCard)
        ->max('rank');

        if ($resGetUserCards == NULL){
          $rank = 1;
        } else {
          $rank = $resGetUserCards + 1;
        }
    } catch (\Exception $e) {
      return "2";
    }

    // Insert preferences into database
    try {
      $resCreatePreference = DB::table('properties')->insert(
        ['users_id_user' => $userID,
         'cards_id_card' => $resCreateCard,
         'rank' => $rank,
         'rights' => '',
         'filter_perso' => '',
         'filter_general' => '']
      );
    } catch (\Exception $e) {
      return "3";
    }

    // Insert logs into database
    try {
      $resCreateLog = DB::table('logs')->insert(
        ['users_id_user' => $userID,
         'cards_id_card' => $resCreateCard,
         'type' => 'Creation',
         'content' => 'Card',
         'date' => date('Y-m-d H:i:s')]
      );
      return "0";
    } catch (\Exception $e) {
      return "4";
    }

  }


// Get cards from user
static public function GetCard ($userToken){
    try {
      $cardsProperties = [];
      $userID = user::GetUserID($userToken);
      $resGetCardsFromUser = DB::table('properties')
        ->join('cards', 'cards.id_card', '=', 'properties.cards_id_card')
        ->select('cards.id_card','cards.title','cards.priority','cards.status','cards.deadline','cards.category','properties.rank')
        ->where('properties.users_id_user','=',$userID)
        ->get();
      foreach ($resGetCardsFromUser as $key => $value)
      {
        $collaborators = [];
        $resGetCollabortorsFromCard = DB::table('properties')
          ->join('users', 'users.id_user', '=', 'properties.users_id_user')
          ->select('users.id_user','users.avatar')
          ->where('properties.cards_id_card','=',$value -> id_card)
          ->get();
        foreach ($resGetCollabortorsFromCard as $key => $v)
        {
          $collaborators[] = $v->avatar;
        }
        $cardsProperties[] = new Card(
         $value -> id_card,
         $value -> title,
         $value -> priority,
         $value -> status,
         $value -> deadline,
         $value -> category,
         $value -> rank,
         $collaborators
        );
      }
      return $cardsProperties;

    } catch (\Exception $e) {
      return "4";
    }


  }

}
