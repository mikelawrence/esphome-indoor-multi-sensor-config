import os
from pathlib import Path
from elevenlabs.client import ElevenLabs

def get_voice_id_by_name(target_voice_name):
    """
    Retrieves the voice_id for a given voice name.

    :param target_voice_name: The name of the voice to search for (e.g., "Adam").
    :return: The voice_id if found, otherwise None.
    """
    # Fetch all available voices
    response = client.voices.get_all()
    all_voices = response.voices

    # Iterate through the voices to find a name match
    for voice in all_voices:
        # print(f"Searching voice '{voice.name}' with ID: {voice.voice_id}")
        if voice.name == target_voice_name:
            print(f"Found voice '{target_voice_name}' with ID: {voice.voice_id}")
            return voice.voice_id

    print(f"Voice '{target_voice_name}' not found.")
    return None

if os.getenv("ELEVENLABS_API_KEY") is None:
    print("Please set the ELEVENLABS_API_KEY environment variable.")
else:
    client = ElevenLabs()

    # # voice_name = "Adam"
    # # folder_name = "adam-male"
    # # voice_name = "Adam - American, Dark and Tough"
    # # folder_name = "adam-dark-male"
    # # voice_name = "Katie X - Call Center English Female"
    # # folder_name = "katie-x-female"
    # voice_name = "Eryn - Informative, Neutral and Measured"
    # folder_name = "eryn-informative-female"
    # voice_name = "River"
    # folder_name = "river-female"

    voices = {
        "adam-male": "Adam",
        "adam-dark-male": "Adam - American, Dark and Tough",
        "katie-x-female": "Katie X - Call Center English Female",
        "eryn-informative-female": "Eryn - Informative, Neutral and Measured",
        "river-female": "River",
        "northern-terry-male": "Northern Terry",
        "lucy-fresh-female": "Lucy - Fresh & Casual",
    }

    sentences = {
        "alarm-silenced": "Alarm silenced.",
        "alarm-cannot-be-silenced": "Alarm cannot be silenced.",
    }

    rooms = {
        "aj-room": "in AJ's Room",
        "bedroom": "in the Bedroom",
        "brisa-room": "in Brisa's Room",
        "dining-room": "in the Dining Room",
        "den": "in the Den",
        "entry-hallway": "in the Entry Hallway",
        "family-room": "in the Family Room",
        "game-room": "in the Game Room",
        "garage": "in the Garage",
        "guest-bathroom": "in the Guest Bathroom",
        "guest-bedroom": "in the Guest Bedroom",
        "hallway": "in the Hallway",
        "kids-bathroom": "in the Kids Bathroom",
        "kids-bedroom": "in the Kids Bedroom",
        "kitchen": "in the Kitchen",
        "laundry-room": "in the Laundry Room",
        "living-room": "in the Living Room",
        "master-bathroom": "in the Master Bathroom",
        "master-bedroom": "in the Master Bedroom",
        "master-closet": "in the Master Closet",
        "master-toilet": "in the Master Toilet",
        "noah-room": "in Noah's Room",
        "nursery": "in the Nursery",
        "office": "in the Office",
        "pantry": "in the Pantry",
        "spare-bathroom": "in the Spare Bathroom",
        "spare-bedroom": "in the Spare Bedroom",
        "stairs": "on the Stairs",
        "study": "in the Study",
        "theater": "in the Theater",
        "utility-room": "in the Utility Room",
        "up-bathroom": "in the Up Bathroom",
    }

    sentences_rooms = {
        "operational": "Multi-Sensor is operational {0}.",
        "co2-warning": "Warning! Carbon Dioxide levels are elevated {0}!",
        "co-warning": "Warning! Carbon Monoxide levels are elevated {0}!",
        "co-danger": "Danger! Carbon Monoxide levels are high {0}!",
        "smoke-danger": "Danger! Smoke detected {0}! Leave the area immediately!",
        "pm-warning": "Warning! Particulate Matter levels are elevated {0}!",
    }

    for voice_foldername, voice_name in voices.items():
        voice_id = get_voice_id_by_name(voice_name)
        # add single sentences without room context
        for sentence_name, sentence_text in sentences.items():
            speak = sentence_text
            filename = Path("./sounds") / f"{voice_foldername}"
            filename.mkdir(parents=True, exist_ok=True)
            filename = filename / f"{sentence_name}.mp3"
            if filename.exists():
                print(f"File '{filename}' already exists, skipping...")
            else:
                print(f"Creating '{filename}' with text '{speak}'...")
                audio = client.text_to_speech.convert(
                    text=speak,
                    voice_id=voice_id,
                    model_id="eleven_multilingual_v2",
                    output_format="mp3_24000_48",
                )
                with open(filename, "wb") as f:
                    for chunk in audio:
                        f.write(chunk)
        
        # add all combinations of rooms and sentences
        for room_name, room_text in rooms.items():
            for sentence_name, sentence_text in sentences_rooms.items():
                speak = sentence_text.format(room_text)
                filename = Path("./sounds") / f"{voice_foldername}"/ f"{room_name}"
                filename.mkdir(parents=True, exist_ok=True)
                filename = filename / f"{sentence_name}.mp3"
                if filename.exists():
                    print(f"File '{filename}' already exists, skipping...")
                else:
                    print(f"Creating '{filename}' with text '{speak}'...")
                    audio = client.text_to_speech.convert(
                        text=speak,
                        voice_id=voice_id,
                        model_id="eleven_multilingual_v2",
                        output_format="mp3_24000_48",
                    )
                    with open(filename, "wb") as f:
                        for chunk in audio:
                            f.write(chunk)
