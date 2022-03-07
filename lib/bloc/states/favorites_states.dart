import 'package:shop_app/models/change_favorites_model.dart';

abstract class FavoritesStates {}

class FavoritesInitialState extends FavoritesStates{}

class GetTokenState extends FavoritesStates{}

class ChangeFavoriteButtonState extends FavoritesStates{}

class ChangeFavoritesSuccessState extends FavoritesStates{
  final ChangeFavoritesModel model;

  ChangeFavoritesSuccessState(this.model);
}

class ChangeFavoritesErrorState extends FavoritesStates{}

class GetFavoritesLoadingState extends FavoritesStates{}

class GetFavoritesSuccessState extends FavoritesStates{}

class GetFavoritesErrorState extends FavoritesStates{}

