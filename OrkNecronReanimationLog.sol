// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

/// @title Ork vs Necron Reanimation Log
/// @notice Records Ork encounters with Necron units, reanimation events, and phase shift effects.
/// @dev This contract is unique to Necrons due to reanimation and phase shift fields.

contract OrkNecronReanimationLog {

    address constant EXAMPLE_ADDRESS = 0x0000000000000000000000000000000000000001;

    struct Encounter {
        string reanimationProtocol; // What kind of Necron reanimation da boyz saw
        string dynastyMarker;       // Sautekh, Mephrit, Novokh, etc.
        string necronUnitType;      // Immortals, Warriors, Lychguard, Wraiths
        string phaseShiftEvent;     // Teleport, vanish, quantum blink
        string behavior;            // How da shiny gitz acted accordin to da Orks
        string outcome;             // How da scrap ended from da Ork perspective
        address creator;
        uint256 approved;
        uint256 rejected;
        uint256 createdAt;
    }

    Encounter[] public logs;

    mapping(uint256 => mapping(address => bool)) public hasVoted;

    event EncounterRecorded(uint256 indexed id, string dynastyMarker, address indexed creator);
    event EncounterVoted(uint256 indexed id, bool approved, uint256 approvedVotes, uint256 rejectedVotes);

    constructor() {
        logs.push(
            Encounter({
                reanimationProtocol: "Example Reanimation (Fill your own below)",
                dynastyMarker: "Name da dynasty (Sautekh, Mephrit, etc.)",
                necronUnitType: "Describe da shiny git unit type.",
                phaseShiftEvent: "Describe da weird teleport or vanish.",
                behavior: "Describe how da metal gitz acted.",
                outcome: "Describe how da scrap ended accordin to da Orks.",
                creator: EXAMPLE_ADDRESS,
                approved: 0,
                rejected: 0,
                createdAt: block.timestamp
            })
        );
    }

    function recordEncounter(
        string calldata reanimationProtocol,
        string calldata dynastyMarker,
        string calldata necronUnitType,
        string calldata phaseShiftEvent,
        string calldata behavior,
        string calldata outcome
    ) external {
        require(bytes(dynastyMarker).length > 0, "Dynasty required");

        logs.push(
            Encounter({
                reanimationProtocol: reanimationProtocol,
                dynastyMarker: dynastyMarker,
                necronUnitType: necronUnitType,
                phaseShiftEvent: phaseShiftEvent,
                behavior: behavior,
                outcome: outcome,
                creator: msg.sender,
                approved: 0,
                rejected: 0,
                createdAt: block.timestamp
            })
        );

        emit EncounterRecorded(logs.length - 1, dynastyMarker, msg.sender);
    }

    function voteEncounter(uint256 id, bool approved) external {
        require(id < logs.length, "Invalid ID");
        require(!hasVoted[id][msg.sender], "Already voted");

        hasVoted[id][msg.sender] = true;

        Encounter storage e = logs[id];

        if (approved) {
            e.approved += 1;
        } else {
            e.rejected += 1;
        }

        emit EncounterVoted(id, approved, e.approved, e.rejected);
    }

    function totalEncounters() external view returns (uint256) {
        return logs.length;
    }
}
