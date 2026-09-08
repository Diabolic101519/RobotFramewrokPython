def test_example():
    """Sample test to verify pytest configuration."""
    assert 1 + 1 == 2


def test_string_concatenation():
    """Test basic string operations."""
    result = "Hello" + " " + "World"
    assert result == "Hello World"


def test_list_operations():
    """Test basic list operations."""
    test_list = [1, 2, 3, 4, 5]
    assert len(test_list) == 5
    assert test_list[0] == 1
    assert test_list[-1] == 5
