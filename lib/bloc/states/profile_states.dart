abstract class ProfileStates {}

class ProfileInitialState extends ProfileStates {}

class GetTokenState extends ProfileStates {}

class ProfileLoadingState extends ProfileStates {}

class ProfileSuccessState extends ProfileStates {}

class ProfileErrorState extends ProfileStates {}

class ProfileUpdateLoadingState extends ProfileStates {}

class ProfileUpdateSuccessState extends ProfileStates {}

class ProfileUpdateErrorState extends ProfileStates {}